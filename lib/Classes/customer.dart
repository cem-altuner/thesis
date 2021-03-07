class Customer {
  final int uid;
  final String username;
  final String email;
  final bool is_staff;
  final String location;
  final String open_adress;

  Customer(
      {this.uid,
      this.username,
      this.email,
      this.is_staff,
      this.location,
      this.open_adress});

  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
      uid: json['id'],
      username: json['username'],
      email: json['email'],
      is_staff: json['is_staff'],
      location: json['location'],
      open_adress: json['open_adress'],
    );
  }
}
