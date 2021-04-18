module.exports = class Note {
  constructor(object) {
    this.pk = object?.pk;
    this.sk = object?.sk;
    this.name = object?.name;
  }
}