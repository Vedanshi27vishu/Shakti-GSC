import 'package:flutter/material.dart';
//import 'package:get/get.dart';
import 'package:shakti/Screens/labview.dart';
import 'package:shakti/Utils/constants/colors.dart';
import 'package:shakti/helpers/helper_functions.dart';

class GovernmentLoansScreen extends StatelessWidget {
  final List<dynamic> loans;

  const GovernmentLoansScreen({Key? key, required this.loans})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    double height = THelperFunctions.screenHeight(context);
    double width = THelperFunctions.screenWidth(context);

    return Scaffold(
      backgroundColor: Scolor.primary,
      appBar: AppBar(
        backgroundColor: Scolor.primary,
        title: Text(
          "Government Loan Schemes",
          style: TextStyle(
            color: Scolor.white,
            fontSize: height * 0.025,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: IconThemeData(color: Scolor.white),
      ),
      body: Padding(
        padding: EdgeInsets.all(width * 0.04),
        child: loans.isEmpty
            ? Center(
                child: Text(
                  "No loan schemes available",
                  style: TextStyle(
                    color: Scolor.white,
                    fontSize: height * 0.02,
                  ),
                ),
              )
            : ListView.builder(
                itemCount: loans.length,
                itemBuilder: (context, index) {
                  final loan = loans[index];
                  return Container(
                    margin: EdgeInsets.only(bottom: height * 0.02),
                    padding: EdgeInsets.all(width * 0.04),
                    decoration: BoxDecoration(
                      border: Border.all(color: Scolor.secondry),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          loan['name'] ?? 'Unknown Loan',
                          style: TextStyle(
                            color: Scolor.secondry,
                            fontSize: height * 0.022,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: height * 0.01),
                        Text(
                          loan['description'] ?? 'No description available',
                          style: TextStyle(
                            color: Scolor.white,
                            fontSize: height * 0.018,
                          ),
                        ),
                        SizedBox(height: height * 0.015),
                        Text(
                          "Eligibility:",
                          style: TextStyle(
                            color: Scolor.secondry,
                            fontSize: height * 0.02,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: height * 0.008),
                        if (loan['eligibility'] != null) ...[
                          ...List<String>.from(loan['eligibility'])
                              .map((criteria) => Padding(
                                    padding: EdgeInsets.only(
                                        left: width * 0.04,
                                        bottom: height * 0.005),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "• ",
                                          style: TextStyle(
                                            color: Scolor.white,
                                            fontSize: height * 0.016,
                                          ),
                                        ),
                                        Expanded(
                                          child: Text(
                                            criteria,
                                            style: TextStyle(
                                              color: Scolor.white,
                                              fontSize: height * 0.016,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ))
                              .toList(),
                        ],
                        if (loan['link'] != null) ...[
                          SizedBox(height: height * 0.015),
                          GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => LoanWebViewScreen(
                                      url: loan['link'],
                                      title: loan['name'],
                                    ),
                                  ),
                                );
                              },
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Learn More",
                                    style: TextStyle(
                                      color: Scolor.secondry,
                                      fontSize: height * 0.016,
                                      fontWeight: FontWeight.w600,
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                ],
                              )),
                        ],
                      ],
                    ),
                  );
                },
              ),
      ),
    );
  }
}
