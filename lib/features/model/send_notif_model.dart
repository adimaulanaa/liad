class SendNotifModel {
  bool isError;
  String error;

  SendNotifModel({
    this.isError = false,
    this.error = '',
  });
}

class ResponseNotes {
  bool isSucces;
  String message;

  ResponseNotes({
    this.isSucces = false,
    this.message = '',
  });
}
