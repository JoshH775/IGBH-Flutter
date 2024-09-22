class Node {
  int NodeID;
  int yesID;
  int noID;
  double yesMultiplier;
  double noMultiplier;
  String question;

  Node(this.NodeID, this.yesID, this.noID, this.yesMultiplier,
      this.noMultiplier, this.question);

  @override
  String toString() {
    return 'Node {NodeID: $NodeID, yesID: $yesID, noID: $noID, yesMultiplier: $yesMultiplier, noMultiplier: $noMultiplier, question: $question}';
  }
}