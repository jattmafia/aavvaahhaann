// import 'package:flutter/material.dart';
// import 'package:avahan/utils/extensions.dart';

// class PersonalDetailsPage extends StatelessWidget {
//   PersonalDetailsPage({super.key});
//   final formKey = GlobalKey<FormState>();

//   static const route = "/personal-details";
//   @override
//   Widget build(BuildContext context) {
//     final labels = context.labels;
//     final styles = context.style;
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           labels.personalDetails,
//         ),
//       ),
//       body: SafeArea(
//           child: SingleChildScrollView(
//         padding: const EdgeInsets.all(16),
//         child: Form(
//             key: formKey,
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   labels.firstName,
//                   style: styles.titleSmall,
//                 ),
//                 const SizedBox(height: 8),
//                 TextFormField(
//                   initialValue: "",
//                   onSaved: null,
//                   validator: (value) =>
//                       value == null || value.isEmpty ? "Required" : null,
//                 ),
//                 const SizedBox(height: 12),
//                 Text(
//                   labels.lastName,
//                   style: styles.titleSmall,
//                 ),
//                 const SizedBox(height: 8),
//                 TextFormField(
//                   initialValue: "",
//                   onSaved: null,
//                   validator: (value) =>
//                       value == null || value.isEmpty ? "Required" : null,
//                 ),
//                 const SizedBox(height: 12),
//                 Text(
//                   labels.mobileNumber,
//                   style: styles.titleSmall,
//                 ),
//                 const SizedBox(height: 8),
//                 TextFormField(
//                   initialValue: "",
//                   onSaved: null,
//                   validator: (value) =>
//                       value == null || value.isEmpty ? "Required" : null,
//                 ),
//                 const SizedBox(height: 12),
//                 Text(
//                   labels.email,
//                   style: styles.titleSmall,
//                 ),
//                 const SizedBox(height: 8),
//                 TextFormField(
//                   initialValue: "",
//                   onSaved: null,
//                   validator: (value) =>
//                       value == null || value.isEmpty ? "Required" : null,
//                 ),
//                 const SizedBox(height: 20),
//                 Text(
//                   labels.address,
//                   style: styles.titleSmall,
//                 ),
//                 const SizedBox(height: 12),
//                 TextFormField(
//                   initialValue: "",
//                   onSaved: null,
//                   maxLines: 5,
//                   validator: (value) =>
//                       value == null || value.isEmpty ? "Required" : null,
//                 ),
//               ],
//             )),
//       )),
//     );
//   }
// }
