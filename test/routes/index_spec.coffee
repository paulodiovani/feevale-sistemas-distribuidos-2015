describe 'Index', ->
  before ->
    @dummy  = '
      Lorem ipsum dolor sit amet, consectetur adipiscing elit.
      Duis ligula enim, malesuada at nulla in, tincidunt semper
      metus. Integer ex libero, facilisis in luctus non, porttitor
      a ipsum. Nulla et dui ultricies, sodales elit vel, cursus
      massa. In tempus, dui in placerat eleifend, urna urna
      facilisis sem, eget fringilla odio quam ac purus. Duis
      laoreet sapien laoreet quam pellentesque, nec venenatis
      dui fringilla. Donec sed arcu diam. Proin eu urna non purus
      porttitor porttitor eget ut purus. In cursus turpis lorem,
      vitae varius eros consequat sit amet. Fusce eu blandit felis,
      nec placerat arcu. Vestibulum urna dolor, vehicula eget
      aliquet sed, imperdiet a tortor. Nullam vel vulputate metus,
      sollicitudin ullamcorper elit. Aliquam sed orci erat. Maecenas
      imperdiet posuere leo non laoreet.
    '

  describe 'GET /', ->
    it 'shows wellcome message', (done) ->
      request(app)
        .get('/')
        .expect('Content-Type', /html/)
        .expect(200, done)

  describe 'POST /', ->
    it 'counts the ocurrences of a word', (done) ->
      word_search = 'elit'
      request(app)
        .post('/')
        .type('form')
        .send(content: @dummy, search: word_search)
        .expect('Content-Type', /json/)
        .expect(200, {
          search: word_search
          ocurrences: 3
        }, done)

    it 'ignores case', (done) ->
      word_search = 'lorem'
      request(app)
        .post('/')
        .type('form')
        .send(content: @dummy, search: word_search)
        .expect('Content-Type', /json/)
        .expect(200, {
          search: word_search
          ocurrences: 2
        }, done)

    it 'only counts entire words', (done) ->
      word_search = 'et'
      request(app)
        .post('/')
        .type('form')
        .send(content: @dummy, search: word_search)
        .expect('Content-Type', /json/)
        .expect(200, {
          search: word_search
          ocurrences: 1
        }, done)

    it 'return 0 ocurrents if does not match search', (done) ->
      @dummy      = 'not matching text'
      word_search = 'lorem'
      request(app)
        .post('/')
        .type('form')
        .send(content: @dummy, search: word_search)
        .expect('Content-Type', /json/)
        .expect(200, {
          search: word_search
          ocurrences: 0
        }, done)
