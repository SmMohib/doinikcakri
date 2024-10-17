import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:doinikcakri/component/colors.dart';
import 'package:doinikcakri/widgets/texts.dart';

class PolicyPage extends StatelessWidget {
  const PolicyPage({super.key});
  static String text1 =
      "Software Solution Apps built the 'KORMO BARTA' app as a Free app. This SERVICE is provided by Techlab Apps at no cost and is intended for use as is.This page is used to inform visitors regarding my policies with the collection, use, and disclosure of Personal Information if anyone decided to use my Service. If you choose to use my Service,then you gree to the collection and use of information in relation to this policy. \nThe Personal Information that I collect is used for providing and improving the Service. I will not use or share your information with anyone except as described in this Privacy Policy. The terms used in this Privacy Policy have the same meanings as in our Terms and Conditions, which are accessible at JOBappBD unless otherwise defined in this Privacy Policy.";
  static String text2 =
      "For a better experience, while using our Service, I may require you to provide us with certain personally identifiable information, including but not limited to JOBappBD - First of all, this app with all the information related to all the public and private recruitment and examination schedules, results published in various daily magazines and online. So it is a useful application for those who are looking for a job or someone close to them. Check regularly and keep the apps updated. We hope you find the app useful. Download and install the app.. The information that I request will be retained on your device and is not collected by me in any way.";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: primaryColor,
          title: textPoppins(
              text: 'Privacy Policy',
              color: textColor,
              isTile: false,
              fontSize: 16),
        ),
        body: Padding(
          padding: const EdgeInsets.only(left: 15,right: 15),
          child: SingleChildScrollView(
            child: Column(
              children: [
                        textTitle('Our Policy'),
                textDes(text1),
                textTitle('Information Collection and Use'),
                textDes(text2),
                textTitle('Third-party service'),
                textn('#Google Play Services'),
                textn('#AdMob'),
                textn('#Google Analytics'),
                textn('#Firebase Crashlytics'),
                textDes(
                    "\nI want to inform you that whenever you use my Service, in a case of an error in the app I collect data and information (through third-party products) on your phone called Log Data. This Log Data may include information such as your device Internet Protocol (“IP”) address, device name, operating system version, the configuration of the app when utilizing my Service, the time and date of your use of the Service, and other statistics."),
                textTitle('Cookies'),
                textDes(
                    "Cookies are files with a small amount of data that are commonly used as anonymous unique identifiers. These are sent to your browser from the websites that you visit and are stored on your device's internal memory. This Service does not use these “cookies” explicitly.\n\n However, the app may use third-party code and libraries that use “cookies” to collect information and improve their services. You have the option to either accept or refuse these cookies and know when a cookie is being sent to your device. If you choose to refuse our cookies, you may not be able to use some portions of this Service."),
                textTitle('Service Providers'),
                textDes(
                    "To facilitate our Service;\nTo provide the Service on our behalf;\nTo perform Service-related services;\nTo assist us in analyzing how our Service is used.\n\nI want to inform users of this Service that these third parties have access to their Personal Information. The reason is to perform the tasks assigned to them on our behalf. However, they are obligated not to disclose or use the information for any other purpose."),
                textTitle('Security'),
                textDes(
                    "I value your trust in providing us your Personal Information, thus we are striving to use commercially acceptable means of protecting it. But remember that no method of transmission over the internet, or method of electronic storage is 100% secure and reliable, and I cannot guarantee its absolute security."),
               
                textTitle("Children’s Privacy"),
                textDes("These Services do not address anyone under the age of 13. I do not knowingly collect personally identifiable information from children under 13 years of age. In the case I discover that a child under 13 has provided me with personal information, I immediately delete this from our servers. If you are a parent or guardian and you are aware that your child has provided us with personal information, please contact me so that I will be able to do the necessary actions."),
                textTitle('Changes to This Privacy Policy'),
                textDes("'KORMO BART' App has the discretion to update this privacy policy at any time. We encourage Users to frequently check this page for any changes to stay informed about how we are helping to protect the personal information we collect. You acknowledge and agree that it is your responsibility to review this privacy policy periodically and become aware of modifications"),
                textTitle('Contact Us'),
                textDes("If you have any questions or suggestions about my Privacy Policy, do not hesitate to contact me.\nGmail: doinikcakri.info@gmail.com."),
              
              
              ],
            ),
          ),
        ));
  }

  Widget textn(String text) {
    return Column(
      children: [
        Align(
          alignment: Alignment.bottomLeft,
          child: textPoppins(
              text: text, color: textsecondColor, isTile: false, fontSize: 16),
        ),
        const SizedBox(
          height: 5,
        ),
      ],
    );
  }

  Widget textTitle(String text) {
    return Column(
      children: [
        Align(
          alignment: Alignment.bottomLeft,
          child: textPoppins(
              text: text, color: textsecondColor, isTile: true, fontSize: 16),
        ),
        const SizedBox(
          height: 5,
        ),
      ],
    );
  }

  Widget textDes(String text) {
    return Column(
      children: [
        Align(
          alignment: Alignment.bottomLeft,
          child: textPoppins(
              text: text, color: textsecondColor, isTile: false, fontSize: 14),
        ),
        const SizedBox(
          height: 20,
        ),
      ],
    );
  }
}
