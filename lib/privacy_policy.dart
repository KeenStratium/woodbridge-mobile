import 'package:flutter/material.dart';

class PrivacyPolicy extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('myWoodbridge'),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 40.0, horizontal: 20.0),
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.symmetric(vertical: 20.0),
                child: Text(
                  "Privacy Policy",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      color: Colors.black87,
                      fontWeight: FontWeight.w700,
                      fontSize: 24.0
                  ),
                ),
              ),
              Text(
                "Effective date: July 08, 2019\n\n"
                'myWoodbridge ("us", "we", or "our") operates the myWoodbridge mobile application (the "Service").\n\n'
                "This page informs you of our policies regarding the collection, use, and disclosure of personal data when you use our Service and the choices you have associated with that data. Our Privacy Policy for myWoodbridge is created with the help of the Free Privacy Policy Generator.\n\n"
                "We use your data to provide and improve the Service. By using the Service, you agree to the collection and use of information in accordance with this policy. Unless otherwise defined in this Privacy Policy, terms used in this Privacy Policy have the same meanings as in our Terms and Conditions.",
                textAlign: TextAlign.justify,
                style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[800]
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 20.0),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 20.0),
                child: Text(
                  "Information Collection And Use",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      color: Colors.black87,
                      fontWeight: FontWeight.w700,
                      fontSize: 24.0
                  ),
                ),
              ),
              Text(
                'We collect several different types of information for various purposes to provide and improve our Service to you.',
                textAlign: TextAlign.justify,
                style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[800]
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 20.0),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 20.0),
                child: Text(
                  "Types of Data Collected",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      color: Colors.black87,
                      fontWeight: FontWeight.w700,
                      fontSize: 24.0
                  ),
                ),
              ),
              Text(
                'Personal Data\n\n'
                'While using our Service, we may ask you to provide us with certain personally identifiable information that can be used to contact or identify you ("Personal Data"). Personally identifiable information may include, but is not limited to:\n\n'
                '  - Cookies and Usage Data'
                'Usage Data\n\n'
                'When you access the Service by or through a mobile device, we may collect certain information automatically, including, but not limited to, the type of mobile device you use, your mobile device unique ID, the IP address of your mobile device, your mobile operating system, the type of mobile Internet browser you use, unique device identifiers and other diagnostic data ("Usage Data").\n\n'
                'Tracking & Cookies Data\n\n'
                'We use cookies and similar tracking technologies to track the activity on our Service and hold certain information.\n\n'
                'Cookies are files with small amount of data which may include an anonymous unique identifier. Cookies are sent to your browser from a website and stored on your device. Tracking technologies also used are beacons, tags, and scripts to collect and track information and to improve and analyze our Service.\n\n'
                'You can instruct your browser to refuse all cookies or to indicate when a cookie is being sent. However, if you do not accept cookies, you may not be able to use some portions of our Service.\n\n'
                '  - Session Cookies. We use Session Cookies to operate our Service.\n\n'
                '  - Preference Cookies. We use Preference Cookies to remember your preferences and various settings.\n\n'
                '  - Security Cookies. We use Security Cookies for security purposes.',
                textAlign: TextAlign.justify,
                style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[800]
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 20.0),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 20.0),
                child: Text(
                  "Use of Data",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      color: Colors.black87,
                      fontWeight: FontWeight.w700,
                      fontSize: 24.0
                  ),
                ),
              ),
              Text(
                "myWoodbridge uses the collected data for various purposes:\n\n",
                textAlign: TextAlign.justify,
                style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[800]
                ),
              ),
              Text(
                "  - To provide and maintain the Service\n"
                "  - To notify you about changes to our Service\n"
                "  - To allow you to participate in interactive features of our Service when you choose to do so\n"
                "  - To provide customer care and support\n"
                "  - To provide analysis or valuable information so that we can improve the Service\n"
                "  - To monitor the usage of the Service\n"
                "  - To detect, prevent and address technical issues",
                textAlign: TextAlign.left,
                style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[800]
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 20.0),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 20.0),
                child: Text(
                  "Transfer Of Data",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      color: Colors.black87,
                      fontWeight: FontWeight.w700,
                      fontSize: 24.0
                  ),
                ),
              ),
              Text(
                "Your information, including Personal Data, may be transferred to — and maintained on — computers located outside of your state, province, country or other governmental jurisdiction where the data protection laws may differ than those from your jurisdiction.\n\n"
                "If you are located outside Philippines and choose to provide information to us, please note that we transfer the data, including Personal Data, to Philippines and process it there.\n\n"
                "Your consent to this Privacy Policy followed by your submission of such information represents your agreement to that transfer.\n\n"
                "myWoodbridge will take all steps reasonably necessary to ensure that your data is treated securely and in accordance with this Privacy Policy and no transfer of your Personal Data will take place to an organization or a country unless there are adequate controls in place including the security of your data and other personal information.",
                textAlign: TextAlign.justify,
                style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[800]
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 20.0),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 20.0),
                child: Text(
                  "Disclosure Of Data",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      color: Colors.black87,
                      fontWeight: FontWeight.w700,
                      fontSize: 24.0
                  ),
                ),
              ),
              Text(
                "Legal Requirements\n\n",
                textAlign: TextAlign.justify,
                style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[800]
                ),
              ),
              Text(
                "myWoodbridge may disclose your Personal Data in the good faith belief that such action is necessary to:\n\n",
                textAlign: TextAlign.justify,
                style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[800]
                ),
              ),
              Text(
                "  - To comply with a legal obligation\n"
                "  - To protect and defend the rights or property of myWoodbridge\n"
                "  - To prevent or investigate possible wrongdoing in connection with the Service\n"
                "  - To protect the personal safety of users of the Service or the public\n"
                "  - To protect against legal liability",
                textAlign: TextAlign.left,
                style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[800]
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 20.0),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 20.0),
                child: Text(
                  "Security Of Data",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      color: Colors.black87,
                      fontWeight: FontWeight.w700,
                      fontSize: 24.0
                  ),
                ),
              ),
              Text(
                "The security of your data is important to us, but remember that no method of transmission over the Internet, or method of electronic storage is 100% secure. While we strive to use commercially acceptable means to protect your Personal Data, we cannot guarantee its absolute security.",
                textAlign: TextAlign.justify,
                style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[800]
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 20.0),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 20.0),
                child: Text(
                  "Service Providers",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      color: Colors.black87,
                      fontWeight: FontWeight.w700,
                      fontSize: 24.0
                  ),
                ),
              ),
              Text(
                'We may employ third party companies and individuals to facilitate our Service ("Service Providers"), to provide the Service on our behalf, to perform Service-related services or to assist us in analyzing how our Service is used.\n\n',
                textAlign: TextAlign.justify,
                style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[800]
                ),
              ),
              Text(
                'These third parties have access to your Personal Data only to perform these tasks on our behalf and are obligated not to disclose or use it for any other purpose.',
                textAlign: TextAlign.justify,
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[800]
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 20.0),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 20.0),
                child: Text(
                  "Links To Other Sites",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      color: Colors.black87,
                      fontWeight: FontWeight.w700,
                      fontSize: 24.0
                  ),
                ),
              ),
              Text(
                "Our Service may contain links to other sites that are not operated by us. If you click on a third party link, you will be directed to that third party's site. We strongly advise you to review the Privacy Policy of every site you visit.\n\n",
                textAlign: TextAlign.justify,
                style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[800]
                ),
              ),
              Text(
                'We have no control over and assume no responsibility for the content, privacy policies or practices of any third party sites or services.',
                textAlign: TextAlign.justify,
                style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[800]
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 20.0),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 20.0),
                child: Text(
                  "Changes To This Privacy Policy",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      color: Colors.black87,
                      fontWeight: FontWeight.w700,
                      fontSize: 24.0
                  ),
                ),
              ),
              Text(
                "We may update our Privacy Policy from time to time. We will notify you of any changes by posting the new Privacy Policy on this page.\n\n",
                textAlign: TextAlign.justify,
                style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[800]
                ),
              ),
              Text(
                'We will let you know via email and/or a prominent notice on our Service, prior to the change becoming effective and update the "effective date" at the top of this Privacy Policy.\n\n',
                textAlign: TextAlign.justify,
                style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[800]
                ),
              ),
              Text(
                'You are advised to review this Privacy Policy periodically for any changes. Changes to this Privacy Policy are effective when they are posted on this page.',
                textAlign: TextAlign.justify,
                style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[800]
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 20.0),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 20.0),
                child: Text(
                  "Contact Us",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      color: Colors.black87,
                      fontWeight: FontWeight.w700,
                      fontSize: 24.0
                  ),
                ),
              ),
              Text(
                "If you have any questions about this Privacy Policy, please contact us:\n\n",
                textAlign: TextAlign.justify,
                style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[800]
                ),
              ),
              Text(
                "  - By email: stratium.software@gmail.com\n"
                "  - By visiting this page on our website: https://www.stratiumsoftware.com/contact-us/",
                textAlign: TextAlign.left,
                style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[800]
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
