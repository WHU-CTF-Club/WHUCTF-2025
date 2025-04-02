from json import JSONEncoder
import falcon
import json


class ObjEncoder(JSONEncoder):
    def default(self, obj):
        return obj.__dict__


class JSONTranslator:
    def process_request(self, req, resp):
        body = req.stream.read(req.content_length or 0)
        if not body:
            return

        try:
            req.context.doc = json.loads(body.decode('utf-8'))
        except (ValueError, UnicodeDecodeError):
            description = (
                'Could not decode the request body. The '
                'JSON was incorrect or not encoded as '
                'UTF-8.'
            )

            raise falcon.HTTPBadRequest(title='Malformed JSON', description=description)
        

    def process_response(self, req, resp, resource, req_succeeded):
        if hasattr(resp.context, "complete"):
            return
        if not hasattr(resp.context, 'result'):
            return
        resp.status = falcon.HTTP_200
        resp.content_type = 'application/json'
        resp.text = json.dumps(resp.context.result, cls=ObjEncoder, ensure_ascii=False).encode('utf8')
