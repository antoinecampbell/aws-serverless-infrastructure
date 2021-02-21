const NoteRepository = require('../src/note-repository');
const {DynamoDBClient} = require('@aws-sdk/client-dynamodb');
jest.mock('@aws-sdk/client-dynamodb');

describe('NoteRepository', () => {
  let noteRepository;
  DynamoDBClient.prototype.send.mockReturnValue(Promise.resolve({
    Items: [{
      noteId: {'S': '1'}
    }]
  }));

  beforeEach(() => {
    DynamoDBClient.prototype.send.mockClear();
    noteRepository = new NoteRepository();
  });

  it('should fetch all notes', async () => {
    const expected = [{noteId: '1'}];

    const notes = await noteRepository.getNotes();

    expect(notes?.length).toBe(1);
    expect(notes).toEqual(expected);
  });

  it('should fetch all notes, missing items field', async () => {
    DynamoDBClient.prototype.send.mockReturnValue(Promise.resolve({}));

    const notes = await noteRepository.getNotes();

    expect(notes?.length).toBe(0);
    expect(DynamoDBClient.prototype.send).toHaveBeenCalledTimes(1);
  });

  it('should create a note', async () => {
    await noteRepository.createNote({name: 'name1'});

    expect(DynamoDBClient.prototype.send).toHaveBeenCalledTimes(1);
  });
});