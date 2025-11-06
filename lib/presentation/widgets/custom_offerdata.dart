import 'package:real_project/core/constants/app_imports.dart';
import 'package:real_project/offerta_model.dart';
import 'package:real_project/presentation/view_models/bloc/bloc/get_offerta_bloc.dart';

class OfferDialog extends StatefulWidget {
  final VoidCallback onAccepted;
  const OfferDialog({super.key, required this.onAccepted});

  @override
  State<OfferDialog> createState() => _OfferDialogState();
}

class _OfferDialogState extends State<OfferDialog> {
  bool localAccept = false;

  @override
  void initState() {
    super.initState();
    BlocProvider.of<GetOffertaBloc>(context).add(GetOffertaForUserEvent());
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Ommaviy Oferta Shartlari"),
      content: SizedBox(
        width: double.maxFinite,
        child: BlocBuilder<GetOffertaBloc, GetOffertaState>(
          builder: (context, state) {
            if (state is GetOffertaLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is GetOffertaError) {
              return Center(
                child: Text(
                  state.message,
                  style: TextStyle(color: AppColors.red),
                ),
              );
            } else if (state is GetOffertaSuccess) {
              final List<OfferModel> offers = state.result;

              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ...offers.map((offer) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Text(
                          offer.text,
                          style: TextStyle(
                            fontSize: 13.sp,
                            height: 1.5,
                            color: AppColors.black,
                          ),
                        ),
                      );
                    }).toList(),

                    const SizedBox(height: 15),

                    // Rozilik checkbox
                    Row(
                      children: [
                        Checkbox(
                          checkColor: Colors.white,
                          fillColor: MaterialStateProperty.all(AppColors.primaryColor),
                          value: localAccept,
                          onChanged: (value) {
                            setState(() {
                              localAccept = value!;
                            });
                          },
                        ),
                        const Expanded(
                            child: Text("Men ommaviy oferta shartlariga roziman")),
                      ],
                    ),
                  ],
                ),
              );
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
      actions: [
        ElevatedButton(
          onPressed: localAccept
              ? () {
                  widget.onAccepted();
                }
              : null,
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(55.r),
            ),
            backgroundColor: AppColors.primaryColor,
          ),
          child: Text(
            "Tushundim",
            style: TextStyle(color: AppColors.white2),
          ),
        ),
      ],
    );
  }
}
