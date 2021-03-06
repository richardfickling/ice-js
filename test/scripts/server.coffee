assert     = require 'assert'
http       = require 'http'
mockClient = require '../helpers/mockClient'

describe 'Test Server', ->

  describe 'Test Routes', ->
    client = null

    before ->
      client = new mockClient
        disableJavascript: true
        basePath: 'http://localhost:3000'
   
    describe 'basic routing', ->
      it '/', (done) ->
        client.assertRender '/', 'home', done

      it '/aux', (done) ->
        client.assertRender '/aux', 'aux-ok', done

      it '/aux2', (done) ->
        client.assertRender '/aux2', 'aux2-ok', done


    describe 'data api', ->
      it '/data/artists', (done) ->
        http.get 'http://localhost:3000/data/artists', (res) ->
          done assert.equal(res.statusCode, 200)

      it '/data/artists/:id', (done) ->
        http.get 'http://localhost:3000/data/artists/bonobo', (res) ->
          done assert.equal(res.statusCode, 200)

      it '/data/artists/foobar fails', (done) ->
        http.get 'http://localhost:3000/data/artists/foobar', (res) ->
          done assert.equal(res.statusCode, 404)

    describe 'react component rendering', ->
      it 'synchronous react rendering', (done) ->
        client.visit '/react-sync', (err, window) ->
          app = window.document.getElementById('test-inner');
          done assert.equal app.innerHTML, 'This is a react component!'

      it 'asynchronous react rendering', (done) ->
        client.visit '/react-async', (err, window) ->
          app = window.document.getElementById('test-inner');
          done assert.equal app.innerHTML, 'This is a react component!'

    describe 'parameterized routes', ->
      it '/concat/hello/world', (done) ->
        client.assertRender '/concat/hello/world', 'helloworld', done

      it '/concat/123/456', (done) ->
        client.assertRender '/concat/123/456', '123456', done

      it '/concat2/see/spot/run', (done) ->
        client.assertRender '/concat2/see/spot/run', 'seerun', done

      it '/concat2/hi/friend', (done) ->
        client.assertRender '/concat2/hi/friend', 'hifriend', done


    describe 'glob routes', ->
      it '/abcd', (done) ->
        client.assertRender '/abcd', 'ok', done

      it '/abRANDOM1234cd', (done) ->
        client.assertRender '/abRANDOM1234cd', 'ok', done

      # it '/abcdx', (done) ->
      #   client.assertRender '/abcdx', 'test', done


    describe 'regex routes', ->
      it '/fly', (done) ->
        client.assertRender '/fly', 'ok', done

      it '/zyxfly', (done) ->
        client.assertRender '/zyxfly', 'ok', done

      # it '/superflyflyz', (done) ->
      #   client.assertRender '/superflyflyz', 'test', done


    describe 'query parameters', ->
      it '/query?firstname=robert&lastname=paulson', (done) ->
        client.assertRender '/query?first=robert&last=paulson'
          , 'his name is robert paulson', done

      it '/queryMath/?a=1&b=3&c=3&d=7', (done) ->
        client.assertRender '/queryMath/?a=1&b=3&c=3&d=7'
          , '1337', done


    describe 'status code', ->
      it '/status/123 should have status 123', (done) ->
        http.get 'http://localhost:3000/status/123', (res) ->
          done assert.equal(res.statusCode, 123)

      it '/status/456 should have status 456', (done) ->
        http.get 'http://localhost:3000/status/456', (res) ->
          done assert.equal(res.statusCode, 456)