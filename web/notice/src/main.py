from wsgiref.simple_server import make_server

from models import app
from controller import RegisterController, LoginController, NoticeController, HTMLController


app.add_route('/api/register', RegisterController())
app.add_route('/api/login', LoginController())
app.add_route('/api/notice', NoticeController())
app.add_route('/', HTMLController())
app.add_static_route('/', r'/app/static')


if __name__ == '__main__':
    with make_server('', 8000, app) as httpd:
        print('Serving on port 8000...')
        httpd.serve_forever()
