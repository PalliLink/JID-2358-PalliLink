// import 'package:flutter/material.dart';
// import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
// import 'package:intl/intl.dart';
// import 'package:pallinet/components/scheduler.dart';
// import 'package:pallinet/constants.dart';
// import 'package:pallinet/firestore/firestore.dart';
// import 'package:pallinet/models/patient_model.dart';
// import 'package:pallinet/utils.dart';
// import 'package:sliding_up_panel/sliding_up_panel.dart';

// class EditAppointment extends StatelessWidget {
//   const EditAppointment({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(title: const Text('Create Appointment')),
//         body: const Center(
//             child: SingleChildScrollView(child: EditAppointmentContent())));
//   }
// }

// class EditAppointmentContent extends StatefulWidget {
//   const EditAppointmentContent({Key? key}) : super(key: key);

//   @override
//   State<EditAppointmentContent> createState() => EditAppointmentContentState();
// }

// class EditAppointmentContentState extends State<EditAppointmentContent> {
//   bool isPasswordVisible = false;

//   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

//   String? patient;
//   List? practitioners = [];
//   // Physician physician =
//   DateTime appointmentDate = DateTime.now();
//   DateTime appointmentStart = DateTime.now();
//   DateTime appointmentEnd = DateTime.now();
//   String? desc = "";
//   ServiceType? serviceType;

//   final TextEditingController _dateController = TextEditingController();
//   final TextEditingController _timeStartController = TextEditingController();
//   final TextEditingController _timeEndController = TextEditingController();

//   PanelController pc = PanelController();

//   @override
//   Widget build(BuildContext context) {
//     final arguments = ModalRoute.of(context)?.settings.arguments ?? '';
//     return FutureBuilder<List<Map>?>(
//       future: Future.wait(
//           [retrieveAppointment(arguments), retrieveAppointmentCreationInfo()]),
//       builder: ((context, snapshot) {
//         if (snapshot.hasData) {
//           Map<String, dynamic> data = snapshot.data as Map<String, dynamic>;
//           patient = data["patient"];

//           return Stack(children: [
//             Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: Container(
//                 constraints: const BoxConstraints(maxWidth: 1000),
//                 child: Form(
//                   key: _formKey,
//                   child: Column(
//                     mainAxisSize: MainAxisSize.min,
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       gap(),
//                       gap(),
//                       DropdownButtonFormField(
//                           validator: (value) => requiredValue(value),
//                           decoration: const InputDecoration(
//                             hintText: 'Patient',
//                             prefixIcon: Icon(Icons.person),
//                           ),
//                           items: [],
//                           onChanged: null,
//                           value: patient),
//                       gap(),
//                       TextFormField(
//                         enabled: false,
//                         decoration: const InputDecoration(
//                           hintText: 'Not currently functional Physician(s)',
//                           prefixIcon: Icon(Icons.group_add),
//                         ),
//                       ),
//                       gap(),
//                       TextFormField(
//                         keyboardType: TextInputType.multiline,
//                         maxLines: null,
//                         minLines: 3,
//                         onSaved: (value) => {desc = value},
//                         decoration: const InputDecoration(
//                           hintText: 'Notes',
//                           prefixIcon: Icon(Icons.description),
//                         ),
//                       ),
//                       DropdownButtonFormField(
//                         validator: (value) => requiredValue(value),
//                         items: ServiceType.values.map((e) {
//                           return DropdownMenuItem<ServiceType>(
//                             value: e,
//                             child: Text(e.value),
//                           );
//                         }).toList(),
//                         hint: const Text("Visit Type"),
//                         onChanged: (ServiceType? value) {
//                           // debugPrint(value.toString());
//                         },
//                         onSaved: (value) => {serviceType = value},
//                         value: serviceType,
//                       ),
//                       gap(),
//                       TextFormField(
//                         validator: (value) => dateValidation(value),
//                         controller: _dateController,
//                         readOnly: true,
//                         onTap: () => DatePicker.showDatePicker(context,
//                             showTitleActions: true, onChanged: (date) {
//                           appointmentDate = date;
//                         }, onConfirm: (date) {
//                           _dateController.text =
//                               DateFormat('MM/dd/yyyy').format(appointmentDate);
//                         }, currentTime: appointmentDate),
//                         decoration: const InputDecoration(
//                           hintText: 'Date',
//                           prefixIcon: Icon(Icons.calendar_month),
//                           helperText: ' ',
//                         ),
//                       ),
//                       Row(
//                         crossAxisAlignment: CrossAxisAlignment.end,
//                         children: [
//                           Expanded(
//                             flex: 4,
//                             child: TextFormField(
//                                 validator: (value) => timeValidationStart(
//                                     value,
//                                     appointmentDate,
//                                     physicianAppointments,
//                                     _timeEndController),
//                                 controller: _timeStartController,
//                                 readOnly: true,
//                                 onTap: () => DatePicker.showTime12hPicker(
//                                         context,
//                                         showTitleActions: true,
//                                         onChanged: (time) {
//                                       appointmentStart = time;
//                                     }, onConfirm: (time) {
//                                       _timeStartController.text =
//                                           DateFormat("h:mm aa").format(time);
//                                     }, currentTime: appointmentStart),
//                                 decoration: const InputDecoration(
//                                   hintText: 'Time',
//                                   prefixIcon: Icon(Icons.access_time),
//                                   helperText: ' ',
//                                 )),
//                           ),
//                           const Expanded(
//                             flex: 1,
//                             child: SizedBox(),
//                           ),
//                           Expanded(
//                             flex: 4,
//                             child: TextFormField(
//                                 validator: (value) => timeValidationEnd(
//                                     value,
//                                     appointmentDate,
//                                     physicianAppointments,
//                                     _timeStartController),
//                                 controller: _timeEndController,
//                                 readOnly: true,
//                                 onTap: () => DatePicker.showTime12hPicker(
//                                         context,
//                                         showTitleActions: true,
//                                         onChanged: (time) {
//                                       appointmentEnd = time;
//                                     }, onConfirm: (time) {
//                                       _timeEndController.text =
//                                           DateFormat("h:mm aa").format(time);
//                                     }, currentTime: appointmentEnd),
//                                 decoration: const InputDecoration(
//                                   hintText: 'Time',
//                                   prefixIcon: Icon(Icons.access_time),
//                                   helperText: ' ',
//                                 )),
//                           ),
//                         ],
//                       ),
//                       gap(),
//                       ElevatedButton(
//                           onPressed: () {
//                             pc.open();
//                           },
//                           child: const Text("Open calendar")),
//                       ElevatedButton(
//                           onPressed: () {
//                             _formKey.currentState?.save();
//                             DateTime scheduledTimeStart = combinedDateTime(
//                                 appointmentDate, appointmentStart);

//                             DateTime scheduledTimeEnd = combinedDateTime(
//                                 appointmentDate, appointmentEnd);

//                             if (_formKey.currentState?.validate() == true &&
//                                 validateCombinedDateTime(
//                                     scheduledTimeStart, scheduledTimeEnd)) {
//                               Map<String, dynamic> payload = {
//                                 "patient": patient!.name,
//                                 "practitioner": practitioners,
//                                 "description": desc,
//                                 "type": serviceType?.value,
//                                 "scheduledTimeStart": scheduledTimeStart,
//                                 "scheduledTimeEnd": scheduledTimeEnd,
//                               };
//                               createAppointment(payload);

//                               Navigator.pop(context);
//                             }
//                           },
//                           child: const Text("Create Appointment"))
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//             Scheduler(
//               physicianAppointments: physicianAppointments,
//               pc: pc,
//             )
//           ]);
//         } else {
//           return const Text("Loading");
//         }
//       }),
//     );
//   }

//   Widget gap() => const SizedBox(height: 16);
// }

// validateCombinedDateTime(DateTime timeStart, DateTime timeEnd) {
//   return timeStart.isAfter(DateTime.now()) &&
//       timeEnd.isAfter(DateTime.now()) &&
//       timeStart.isBefore(timeEnd);
// }
