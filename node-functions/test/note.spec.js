const Note = require('../src/note');

describe('Note', () => {

  it('should set note fields', () => {
    const note = new Note({name: 'name1', pk: '1', sk: 2, extraField: 'value'});

    expect(note).toEqual({name: 'name1', pk: '1', sk: 2})
  });

});