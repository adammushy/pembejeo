// // ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

// import 'package:flutter/material.dart';
// import 'package:pembejeo/views/other/components/responsive.dart';
// import 'package:pembejeo/views/other/components/utils.dart';

// class MyInfoCard extends StatefulWidget {
//   const MyInfoCard({
//     Key? key,
//   }) : super(key: key);

//   @override
//   State<MyInfoCard> createState() => _MyInfoCardState();
// }

// class _MyInfoCardState extends State<MyInfoCard> {
//   @override
//   Widget build(BuildContext context) {
//     final Size _size = MediaQuery.of(context).size;
//     return Column(
//       children: [
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children:  [
//             TextWidget(
//               size: 14,
//               fontWeight: FontWeight.w400,
//               color: secondary,
//               text: 'Payment Updates',
//             ),
//           ],
//         ),
//         const SizedBox(height: defaultPadding),
//         Responsive(
//           mobile: FileInfoCardGridView(
//             crossAxisCount: _size.width < 650 ? 2 : 4,
//             childAspectRatio: _size.width < 650 ? 1.3 : 1,
//           ),
//           tablet: const FileInfoCardGridView(),
//           desktop: FileInfoCardGridView(
//             childAspectRatio: _size.width < 1400 ? 1.1 : 1.4,
//           ),
//         ),
//       ],
//     );
//   }
// }

// class FileInfoCardGridView extends StatelessWidget {
//   const FileInfoCardGridView({
//     Key? key,
//     this.crossAxisCount = 4,
//     this.childAspectRatio = 1,
//   }) : super(key: key);

//   final int crossAxisCount;
//   final double childAspectRatio;

//   @override
//   Widget build(BuildContext context) {
//     return GridView.builder(
//       physics: const NeverScrollableScrollPhysics(),
//       shrinkWrap: true,
//       itemCount: demoFiles.length,
//       gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//         crossAxisCount: crossAxisCount,
//         crossAxisSpacing: defaultPadding,
//         mainAxisSpacing: defaultPadding,
//         childAspectRatio: childAspectRatio,
//       ),
//       itemBuilder: (context, index) => InfoCard(info: demoFiles[index]),
//     );
//   }
// }
