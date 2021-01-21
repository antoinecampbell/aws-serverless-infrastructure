const NoteRepository = require('./note-repository');

const noteRepository = new NoteRepository();

exports.getNotesHandler = async (event) => {
  let output;
  try {
    console.log('Request:', JSON.stringify(event));
    const notes = await noteRepository.getNotes();
    console.log('Notes', notes);
    output = {
      statusCode: 200,
      body: JSON.stringify(notes)
    }
  } catch (e) {
    console.error('Error fetching notes', e);
    output = {
      statusCode: 500,
      body: JSON.stringify({error: e && e.message})
    }
  }

  return output;
}

exports.createNoteHandler = async (event) => {
  let output;
  try {
    console.log('Request:', JSON.stringify(event));
    const body = JSON.parse(event.body);
    const note = await noteRepository.createNote(body);
    console.log('Notes', note);
    output = {
      statusCode: 201,
      body: JSON.stringify(note)
    }
  } catch (e) {
    console.error('Error creating note', e);
    output = {
      statusCode: 500,
      body: JSON.stringify({error: e && e.message})
    }
  }

  return output;
}
