import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';

class OtpVerificationPage extends StatefulWidget {
  final String email;
  final bool isRegistration;

  const OtpVerificationPage({
    Key? key,
    required this.email,
    this.isRegistration = false,
  }) : super(key: key);

  @override
  _OtpVerificationPageState createState() => _OtpVerificationPageState();
}

class _OtpVerificationPageState extends State<OtpVerificationPage> {
  final List<TextEditingController> _otpControllers =
  List.generate(6, (index) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (index) => FocusNode());
  bool _isLoading = false;
  String _errorMessage = '';
  String? _generatedOtp;
  String? _sessionId;
  final http.Client _client = http.Client();

  final Color primaryColor = Color(0xFFff3377);

  @override
  void initState() {
    super.initState();
    _generateOtp();
    // Set up focus node listeners
    for (int i = 0; i < _focusNodes.length; i++) {
      _focusNodes[i].addListener(() {
        if (!_focusNodes[i].hasFocus && _otpControllers[i].text.isEmpty && i > 0) {
          FocusScope.of(context).requestFocus(_focusNodes[i-1]);
        }
      });
    }
  }

  @override
  void dispose() {
    _client.close();
    for (var controller in _otpControllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  void _saveSessionCookie(http.Response response) {
    final cookie = response.headers['set-cookie'];
    if (cookie != null) {
      final match = RegExp('PHPSESSID=([^;]+)').firstMatch(cookie);
      if (match != null) {
        _sessionId = match.group(1);
      }
    }
  }

  Future<void> _generateOtp() async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      final response = await _client.post(
        Uri.parse('http://192.168.1.7/mobitix/otp.php'),
        headers: {
          'Content-Type': 'application/json',
          if (_sessionId != null) 'Cookie': 'PHPSESSID=$_sessionId',
        },
        body: json.encode({'email': widget.email}),
      );

      _saveSessionCookie(response);

      if (response.body.isEmpty) {
        throw Exception("Server returned empty response");
      }

      final responseData = json.decode(response.body);

      if (responseData['success']) {
        setState(() {
          _generatedOtp = responseData['otp'].toString();
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('OTP sent (Demo: $_generatedOtp)'),
            duration: Duration(seconds: 5),
          ),
        );
      } else {
        setState(() {
          _errorMessage = responseData['message'] ?? 'Failed to generate OTP';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = "Error: ${e.toString().replaceAll('FormatException: ', '')}";
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _verifyUser() async {
    final response = await _client.post(
      Uri.parse('http://192.168.1.7/mobitix/verify_user.php'),
      headers: {
        'Content-Type': 'application/json',
        if (_sessionId != null) 'Cookie': 'PHPSESSID=$_sessionId',
      },
      body: json.encode({'email': widget.email}),
    );

    if (response.body.isEmpty) {
      throw Exception("Empty verification response");
    }

    final verifyData = json.decode(response.body);
    if (!(verifyData['success'] ?? false)) {
      throw Exception(verifyData['message'] ?? 'Verification failed');
    }
  }

  Future<void> _verifyOtp() async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    final otp = _otpControllers.map((c) => c.text).join();

    if (otp.length != 6) {
      setState(() {
        _errorMessage = "Please enter a 6-digit OTP";
        _isLoading = false;
      });
      return;
    }

    try {
      final response = await _client.post(
        Uri.parse('http://192.168.1.7/mobitix/otp.php'),
        headers: {
          'Content-Type': 'application/json',
          if (_sessionId != null) 'Cookie': 'PHPSESSID=$_sessionId',
        },
        body: json.encode({
          'email': widget.email,
          'user_otp': otp,
        }),
      );

      _saveSessionCookie(response);

      if (response.body.isEmpty) {
        throw Exception("Server returned empty response");
      }

      final responseData = json.decode(response.body);

      if (responseData['success']) {
        if (widget.isRegistration) {
          await _verifyUser();
        }
        // Return success to parent
        Navigator.of(context).pop(true);
      } else {
        setState(() {
          _errorMessage = responseData['message'] ?? 'Invalid OTP';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = "Error: ${e.toString().replaceAll('FormatException: ', '')}";
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Prevent back button from generating new OTP
        Navigator.of(context).pop(false);
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('OTP Verification'),
          backgroundColor: primaryColor,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pop(false);
            },
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height -
                  kToolbarHeight -
                  MediaQuery.of(context).padding.top,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Enter the 6-digit code sent to',
                      style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                    ),
                    Text(
                      widget.email,
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                    SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: List.generate(6, (index) {
                        return SizedBox(
                          width: 45,
                          child: TextField(
                            controller: _otpControllers[index],
                            focusNode: _focusNodes[index],
                            keyboardType: TextInputType.number,
                            textAlign: TextAlign.center,
                            maxLength: 1,
                            decoration: InputDecoration(
                              counterText: '',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              filled: true,
                              fillColor: Colors.grey[100],
                            ),
                            onChanged: (value) {
                              if (value.length == 1 && index < 5) {
                                FocusScope.of(context).requestFocus(_focusNodes[index + 1]);
                              } else if (value.isEmpty && index > 0) {
                                _otpControllers[index].clear();
                                FocusScope.of(context).requestFocus(_focusNodes[index - 1]);
                              }
                            },
                          ),
                        );
                      }),
                    ),
                    SizedBox(height: 16),
                    if (_errorMessage.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Text(
                          _errorMessage,
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: 14,
                          ),
                        ),
                      ),
                  ],
                ),
                Column(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _verifyOtp,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                          padding: EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: _isLoading
                            ? SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                            : Text(
                          'VERIFY OTP',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    Center(
                      child: TextButton(
                        onPressed: _isLoading ? null : _generateOtp,
                        child: Text(
                          'Resend OTP',
                          style: TextStyle(
                            color: primaryColor,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}