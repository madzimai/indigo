from nose.tools import *
from rest_framework.test import APITestCase

from indigo_api.tests.fixtures import *

class SimpleTest(APITestCase):
    fixtures = ['user']

    def setUp(self):
        self.client.login(username='email@example.com', password='password')

    def test_simple_create(self):
        response = self.client.post('/api/documents', {
            'frbr_uri': '/za/act/1998/2/'
        })

        self.assertEqual(response.status_code, 201)
        assert_equal(response.data['frbr_uri'], '/za/act/1998/2/')
        assert_equal(response.data['title'], '(untitled)')
        assert_equal(response.data['nature'], 'act')
        assert_equal(response.data['year'], '1998')
        assert_equal(response.data['number'], '2')

        # these should not be included directly, they should have URLs
        id = response.data['id']
        assert_not_in('body', response.data)
        assert_not_in('content', response.data)
        assert_equal(response.data['body_url'], 'http://testserver/api/documents/%s/body' % id)
        assert_equal(response.data['content_url'], 'http://testserver/api/documents/%s/content' % id)

        response = self.client.get('/api/documents/%s/body' % response.data['id'])
        self.assertEqual(response.status_code, 200)

        assert_equal(response.data['body'], '<body xmlns="http://www.akomantoso.org/2.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">\n  <section id="section-1">\n    <content>\n      <p/>\n    </content>\n  </section>\n</body>\n')


    def test_update_body(self):
        response = self.client.post('/api/documents', {'frbr_uri': '/za/act/1998/2/'})
        self.assertEqual(response.status_code, 201)
        id = response.data['id']

        response = self.client.patch('/api/documents/%s' % id, {'body': body_fixture('in the body')})
        self.assertEqual(response.status_code, 200)

        response = self.client.get('/api/documents/%s/body' % id)
        self.assertEqual(response.status_code, 200)
        assert_in('<p>in the body</p>', response.data['body'])

        # also try updating the body at /body
        response = self.client.put('/api/documents/%s/body' % id, {'body': body_fixture('also in the body')})
        self.assertEqual(response.status_code, 200)

        response = self.client.get('/api/documents/%s/body' % id)
        self.assertEqual(response.status_code, 200)
        assert_in('<p>also in the body</p>', response.data['body'])

    def test_create_with_body(self):
        response = self.client.post('/api/documents', {
            'frbr_uri': '/za/act/1998/2/',
            'body': body_fixture('in the body'),
            })
        self.assertEqual(response.status_code, 201)
        id = response.data['id']

        response = self.client.get('/api/documents/%s/body' % id)
        self.assertEqual(response.status_code, 200)
        assert_in('<p>in the body</p>', response.data['body'])

    def test_update_content(self):
        response = self.client.post('/api/documents', {'frbr_uri': '/za/act/1998/2/'})
        self.assertEqual(response.status_code, 201)
        id = response.data['id']

        response = self.client.patch('/api/documents/%s' % id, {'content': document_fixture('in the body')})
        self.assertEqual(response.status_code, 200)

        response = self.client.get('/api/documents/%s/content' % id)
        self.assertEqual(response.status_code, 200)
        assert_in('<p>in the body</p>', response.data['content'])

        # also try updating the content at /content
        response = self.client.put('/api/documents/%s/content' % id, {'content': document_fixture('also in the body')})
        self.assertEqual(response.status_code, 200)

        response = self.client.get('/api/documents/%s/content' % id)
        self.assertEqual(response.status_code, 200)
        assert_in('<p>also in the body</p>', response.data['content'])

    def test_create_with_content(self):
        response = self.client.post('/api/documents', {
            'frbr_uri': '/za/act/1998/2/',
            'content': document_fixture('in the body'),
            })
        self.assertEqual(response.status_code, 201)
        id = response.data['id']

        response = self.client.get('/api/documents/%s/content' % id)
        self.assertEqual(response.status_code, 200)
        assert_in('<p>in the body</p>', response.data['content'])
