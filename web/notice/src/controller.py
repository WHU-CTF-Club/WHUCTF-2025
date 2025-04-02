from hashlib import md5
import falcon
import uuid
import json

from store import USERS, NOTICES, TOKENS
from models import User, Notice, Token
from utils import merge


def authorization(router_func):
    def wrapper(*args, **kw):
        req = args[1]
        resp = args[2]
        token = req.get_header('Authorization')
        if not token:
            raise falcon.HTTPUnauthorized()
        for t in TOKENS:
            if t.token == token and t.username == "admin":
                return router_func(*args, **kw)
        raise falcon.HTTPUnauthorized()

    return wrapper


class RegisterController:
    def on_post(self, req, resp):
        if not {'username', 'password'}.issubset(req.context.doc.keys()):
            raise falcon.HTTPBadRequest()
        username = req.context.doc['username']
        password = md5(req.context.doc['password'].encode()).hexdigest()

        for user in USERS:
            if user.name == username:
                raise falcon.HTTPBadRequest(title='invalid name')

        USERS.append(User(username.lower(), password.lower()))
        resp.context.result = {'res': 'success'}


class LoginController:
    def on_post(self, req, resp):
        if not {'username', 'password'}.issubset(req.context.doc.keys()):
            raise falcon.HTTPBadRequest()
        username = req.context.doc['username']
        password = md5(req.context.doc['password'].encode()).hexdigest()

        for user in USERS:
            if user.name == username and user.secret == password:
                token = uuid.uuid4().hex
                TOKENS.append(Token(token, user.name))
                resp.context.result = {'res': 'success', 'token': token}
                return

        resp.status = falcon.HTTP_403
        resp.content_type = 'application/json'
        resp.text = json.dumps({'res': 'wrong username or password'})


class NoticeController:
    def on_get(self, req, resp):
        resp.context.result = NOTICES

    @authorization
    def on_put(self, req, resp):
        if not {'title', 'number', 'content'}.issubset(req.context.doc.keys()) :
            raise falcon.HTTPBadRequest()
        NOTICES.append(Notice(req.context.doc['title'], req.context.doc['number'], req.context.doc['content']))
        resp.context.result = {'res': 'success'}
        
    @authorization
    def on_delete(self, req, resp):
        if 'number' not in req.context.doc.keys():
            raise falcon.HTTPBadRequest()
        for n,notice in enumerate(NOTICES):
            if notice.number == req.context.doc['number']:
                del NOTICES[n]

        resp.context.result = {'res': 'success'}

    @authorization
    def on_post(self, req, resp):
        if not {'title', 'number', 'content'}.issubset(req.context.doc.keys()) :
            raise falcon.HTTPBadRequest()
        for n,notice in enumerate(NOTICES):
            if notice.number == req.context.doc['number']:
                merge(req.context.doc, notice)
        
        resp.context.result = {'res': 'success'}


class HTMLController:
    def on_get(self, req, resp):
        resp.status = falcon.HTTP_301
        resp.location = '/index.html'
