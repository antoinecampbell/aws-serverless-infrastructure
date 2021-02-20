const NoteRepository = require('../src/note-repository');
const handler = require('../src/index');

describe('Handler', () => {
  let repositorySpy;
  let getNotesSpy;
  let createNoteSpy;

  beforeEach(() => {
    repositorySpy = spyOnAllFunctions(NoteRepository);
    getNotesSpy = spyOn(repositorySpy.prototype, 'getNotes').and.returnValue(Promise.resolve([
      {name: 'note1'},
      {name: 'note2'},
    ]));
    createNoteSpy = spyOn(repositorySpy.prototype, 'createNote').and.returnValue(Promise.resolve({
      name: 'note1'
    }));
  });

  it('should fetch notes', async () => {
    const response = await handler.getNotesHandler({});

    expect(response).toEqual({
      statusCode: 200,
      body: JSON.stringify([{name: 'note1'}, {name: 'note2'}])
    });
  });

  it('should fail to fetch notes', async () => {
    getNotesSpy.and.returnValue(Promise.reject({message: 'error'}));
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

  it('should fail tocreate note', async () => {
    createNoteSpy.and.returnValue(Promise.reject({message: 'error'}));
    const response = await handler.createNoteHandler({
      body: JSON.stringify({name: 'note1'})
    });

    expect(response).toEqual({
      statusCode: 500,
      body: JSON.stringify({error: 'error'})
    });
  });

});