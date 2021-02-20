const NoteRepository = require('../src/note-repository');
const {DynamoDBClient} = require('@aws-sdk/client-dynamodb');

describe('NoteRepository', () => {
  let noteRepository;
  let dynamoSpy;
  let sendSpy;

  beforeEach(() => {
    dynamoSpy = spyOnAllFunctions(DynamoDBClient);
    noteRepository = new NoteRepository();
    sendSpy = spyOn(dynamoSpy.prototype, 'send').and.returnValue(Promise.resolve({
      Items: [{
        noteId: {'S': '1'}
      }]
    }));
  });

  it('should fetch all notes', async () => {
    const expected = [{noteId: '1'}];

    const notes = await noteRepository.getNotes();

    expect(notes?.length).toBe(1);
    expect(notes).toEqual(expected);
  });

  it('should fetch all notes, missing items field', async () => {
    sendSpy.and.returnValue(Promise.resolve({}));

    const notes = await noteRepository.getNotes();

    expect(notes?.length).toBe(0);
    expect(sendSpy).toHaveBeenCalledTimes(1);
  });

  it('should create a note', async () => {
    await noteRepository.createNote({name: 'name1'});

    expect(sendSpy).toHaveBeenCalledTimes(1);
  });
});