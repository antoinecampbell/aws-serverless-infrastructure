const handler = require('../src/index');
const NoteRepository = require('../src/note-repository');
jest.mock('../src/note-repository');

describe('Handler', () => {

  NoteRepository.prototype.getNotes.mockReturnValue(Promise.resolve([
    {name: 'note1'},
    {name: 'note2'},
  ]));
  NoteRepository.prototype.createNote.mockReturnValue(Promise.resolve({
    name: 'note1'
  }));

  it('should fetch notes', async () => {
    const response = await handler.getNotesHandler({});

    expect(response).toEqual({
      statusCode: 200,
      body: JSON.stringify([{name: 'note1'}, {name: 'note2'}])
    });
  });

  it('should fail to fetch notes', async () => {
    NoteRepository.prototype.getNotes.mockReturnValue(Promise.reject({message: 'error'}));
    const response = await handler.getNotesHandler({});

    expect(response).toEqual({
      statusCode: 500,
      body: JSON.stringify({error: 'error'})
    });
  });

  it('should create note', async () => {
    const response = await handler.createNoteHandler({
      body: JSON.stringify({name: 'note1'})
    });

    expect(response).toEqual({
      statusCode: 201,
      body: JSON.stringify({name: 'note1'})
    });
  });

  it('should fail to create note', async () => {
    NoteRepository.prototype.createNote.mockReturnValue(Promise.reject({message: 'error'}));
    const response = await handler.createNoteHandler({
      body: JSON.stringify({name: 'note1'})
    });

    expect(response).toEqual({
      statusCode: 500,
      body: JSON.stringify({error: 'error'})
    });
  });

});