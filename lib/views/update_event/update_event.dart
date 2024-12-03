import 'package:event/controller/data_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../utils/app_color.dart';
import '../../widgets/my_widgets.dart';


class UpdateEventView extends StatefulWidget {
  final Map<String, dynamic> eventData;
  final String eventId;

  const UpdateEventView({
    Key? key,
    required this.eventData,
    required this.eventId,
  }) : super(key: key);

  @override
  State<UpdateEventView> createState() => _UpdateEventViewState();
}

class _UpdateEventViewState extends State<UpdateEventView> {
  TextEditingController titleController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController startTimeController = TextEditingController();
  TextEditingController endTimeController = TextEditingController();
  TextEditingController maxEntriesController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController tagsController = TextEditingController();

  DateTime? date;
  TimeOfDay? startTime;
  TimeOfDay? endTime;
  var isUpdatingEvent = false.obs;

  @override
  void initState() {
    super.initState();
    // Initialize controllers with event data
    titleController.text = widget.eventData['event_name'];
    locationController.text = widget.eventData['location'];
    dateController.text = widget.eventData['date'];
    startTimeController.text = widget.eventData['start_time'];
    endTimeController.text = widget.eventData['end_time'];
    maxEntriesController.text = widget.eventData['max_entries'].toString();
    priceController.text = widget.eventData['price'];
    descriptionController.text = widget.eventData['description'];
    tagsController.text = widget.eventData['tags'].join(',');
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2015),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        date = picked;
        dateController.text = '${picked.day}-${picked.month}-${picked.year}';
      });
    }
  }

  Future<void> _selectTime(BuildContext context, bool isStartTime) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        if (isStartTime) {
          startTime = picked;
          startTimeController.text = picked.format(context);
        } else {
          endTime = picked;
          endTimeController.text = picked.format(context);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Update Event"),
        backgroundColor: AppColors.blue,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                myTextField(
                  bool: false,
                  icon: 'assets/4DotIcon.png',
                  text: 'Event Name',
                  controller: titleController,
                  validator: (input) {
                    if (input!.isEmpty) return 'Event name is required';
                    return null;
                  },
                ),
                SizedBox(height: 16),
                myTextField(
                  bool: false,
                  icon: 'assets/location.png',
                  text: 'Location',
                  controller: locationController,
                  validator: (input) {
                    if (input!.isEmpty) return 'Location is required';
                    return null;
                  },
                ),
                SizedBox(height: 16),
                iconTitleContainer(
                  path: 'assets/Frame1.png',
                  text: 'Date',
                  controller: dateController,
                  isReadOnly: true,
                  onPress: () => _selectDate(context),
                ),
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: iconTitleContainer(
                        path: 'assets/time.png',
                        text: 'Start Time',
                        controller: startTimeController,
                        isReadOnly: true,
                        onPress: () => _selectTime(context, true),
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: iconTitleContainer(
                        path: 'assets/time.png',
                        text: 'End Time',
                        controller: endTimeController,
                        isReadOnly: true,
                        onPress: () => _selectTime(context, false),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                myTextField(
                  bool: false,
                  icon: 'assets/#.png',
                  text: 'Max Entries',
                  controller: maxEntriesController,
                 
                  validator: (input) {
                    if (input!.isEmpty) return 'Max entries is required';
                    return null;
                  },
                ),
                SizedBox(height: 16),
                myTextField(
                  bool: false,
                  icon: 'assets/dollarLogo.png',
                  text: 'Price',
                  controller: priceController,
                 
                  validator: (input) {
                    if (input!.isEmpty) return 'Price is required';
                    return null;
                  },
                ),
                SizedBox(height: 16),
                myTextField(
                  bool: false,
                  icon: 'assets/#.png',
                  text: 'Tags',
                  controller: tagsController,
                  validator: (input) {
                    if (input!.isEmpty) return 'Tags are required';
                    return null;
                  },
                ),
                SizedBox(height: 16),
                Container(
                  height: 150,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.genderTextColor),
                  ),
                  child: TextFormField(
                    controller: descriptionController,
                    maxLines: 5,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.all(12),
                      hintText: 'Description',
                    ),
                  ),
                ),
                SizedBox(height: 32),
                Obx(() => isUpdatingEvent.value
                    ? Center(child: CircularProgressIndicator())
                    : SizedBox(
                        width: double.infinity,
                        child: elevatedButton(
                          onpress: () async {
                            isUpdatingEvent(true);

                            Map<String, dynamic> updatedData = {
                              'event_name': titleController.text,
                              'location': locationController.text,
                              'date': dateController.text,
                              'start_time': startTimeController.text,
                              'end_time': endTimeController.text,
                              'max_entries': int.parse(maxEntriesController.text),
                              'price': priceController.text,
                              'description': descriptionController.text,
                              'tags': tagsController.text.split(','),
                            };

                            DataController dataController = Get.find();
                            bool success = await dataController.updateEvent(
                              widget.eventId,
                              updatedData,
                            );

                            if (success) {
                              Get.back();
                              Get.snackbar('Success', 'Event updated successfully',
                                  colorText: Colors.white,
                                  backgroundColor: AppColors.blue);
                            } else {
                              Get.snackbar('Error', 'Failed to update event',
                                  colorText: Colors.white,
                                  backgroundColor: Colors.red);
                            }

                            isUpdatingEvent(false);
                          },
                          text: 'Update Event',
                        ),
                      )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
