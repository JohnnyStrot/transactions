import 'package:transactions/data/model/company.dart';
import 'package:transactions/ui/company/company_details_viewmodel.dart';
import 'package:transactions/ui/core/themes/dimens.dart';
import 'package:transactions/ui/details/details_view.dart';
import 'package:flutter/material.dart';

class CompanyDetails
    extends DetailsView<Company, CompanyDetails, CompanyDetailsViewmodel> {
  const CompanyDetails({super.key, required super.viewmodel});

  @override
  State<CompanyDetails> createState() => _CompanyDetailsState();
}

class _CompanyDetailsState
    extends DetailsState<Company, CompanyDetails, CompanyDetailsViewmodel> {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ListenableBuilder(
      listenable: Listenable.merge([
        widget.viewmodel.createEntity,
        widget.viewmodel.loadEntity,
        widget.viewmodel.saveEntity,
      ]),
      builder: (context, _) {
        final company = widget.viewmodel.entity;
        if (company != null) {
          return Form(
            key: formKey,
            child: Scaffold(
              floatingActionButton: FloatingActionButton(
                onPressed: submit,
                child: Icon(Icons.save),
              ),
              appBar: AppBar(
                title: Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: "Marke ",
                        style: TextStyle(fontWeight: FontWeight.w200),
                      ),
                      TextSpan(
                        text: company.name.isEmpty
                            ? "#${company.id}"
                            : company.name,
                        style: TextStyle(
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                    style: TextTheme.of(context).headlineSmall!.copyWith(
                      fontSize: 16,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ),
              body: ListView(
                padding: EdgeInsets.symmetric(
                  vertical: Dimens.of(context).paddingScreenVertical,
                  horizontal: Dimens.of(context).paddingScreenHorizontal,
                ),
                children: [
                  TextFormField(
                    controller: TextEditingController(text: company.name),
                    onChanged: (value) => company.name = value,
                    decoration: InputDecoration(
                      label: Text("Name"),
                      filled: true,
                      border: UnderlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 8.0),
                  TextFormField(
                    initialValue: company.logo,
                    onChanged: (value) => company.logo = value,
                    decoration: InputDecoration(label: Text("Logo (Link)")),
                  ),
                ],
              ),
            ),
          );
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  @override
  String get typeDisplay => "Marke";
}
