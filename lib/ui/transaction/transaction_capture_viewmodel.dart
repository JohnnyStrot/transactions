import 'package:auto_hyphenating_text/auto_hyphenating_text.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_command/flutter_command.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:provider/provider.dart';
import 'package:transactions/data/model/product.dart';
import 'package:transactions/data/model/transaction.dart';
import 'package:transactions/data/model/transaction_part.dart';
import 'package:transactions/data/model/transaction_partner.dart';
import 'package:transactions/data/repositories/product/product_repository.dart';
import 'package:transactions/data/repositories/transaction/transaction_repository.dart';
import 'package:transactions/data/repositories/transaction_partner/transaction_partner_repository.dart';
import 'package:transactions/ui/core/themes/dimens.dart';
import 'package:transactions/ui/product/product_details.dart';
import 'package:transactions/ui/product/product_details_viewmodel.dart';
import 'package:transactions/ui/product/product_picker.dart';
import 'package:transactions/utils/double_to_string_extension.dart';
import 'package:transactions/utils/result.dart';

class TransactionCaptureViewmodel with ChangeNotifier {
  final TransactionRepository repository;
  final TransactionPartnerRepository partnerRepository;
  final ProductRepository productRepository;

  Command<DateTime, DateTime> changeTimestamp;
  late Command<TransactionPartner?, TransactionPartner?> changePartner;

  List<TransactionPartContent> transactionParts = [];

  String? _partnerSearchText;
  String? _partnerCityText;

  String? _productNameText;
  String? _productProducerText;

  late final PagingController<int, TransactionPartner> partnerPagingController;
  late final PagingController<int, (Product, double?)> productPagingController;

  late final ScrollController scrollControllerParts;

  TransactionCaptureViewmodel({
    required this.repository,
    required this.partnerRepository,
    required this.productRepository,
  }) : changeTimestamp = CommandSync(
         initialValue: DateTime.now(),
         restriction: null,
         ifRestrictedExecuteInstead: null,
         includeLastResultInCommandResults: false,
         noReturnValue: false,
         errorFilter: null,
         notifyOnlyWhenValueChanges: true,
         name: null,
         noParamValue: false,
         func: (val) {
           return val;
         },
       ),
       remark = "" {
    changePartner = CommandSync(
      initialValue: null,
      restriction: null,
      ifRestrictedExecuteInstead: null,
      includeLastResultInCommandResults: false,
      noReturnValue: false,
      errorFilter: null,
      notifyOnlyWhenValueChanges: true,
      name: null,
      noParamValue: false,
      func: (val) {
        productPagingController.refresh();
        return val;
      },
    );
    scrollControllerParts = ScrollController();
    partnerPagingController = PagingController<int, TransactionPartner>(
      getNextPageKey: (state) =>
          state.lastPageIsEmpty ? null : state.nextIntPageKey,

      fetchPage: (pageKey) => partnerRepository
          .searchPartner(pageKey, _partnerSearchText, _partnerCityText)
          .then((v) {
            switch (v) {
              case Ok<List<TransactionPartner>>():
                return v.value;
              case Error<List<TransactionPartner>>():
                return [];
            }
          }),
    );
    productPagingController = PagingController<int, (Product, double?)>(
      getNextPageKey: (state) =>
          state.lastPageIsEmpty ? null : state.nextIntPageKey,

      fetchPage: (pageKey) => productRepository
          .searchWithPrice(
            pageKey,
            changePartner.value,
            _productNameText,
            _productProducerText,
          )
          .then((v) {
            switch (v) {
              case Ok<List<(Product, double?)>>():
                return v.value;
              case Error<List<(Product, double?)>>():
                return [];
            }
          }),
    );
  }

  void changeDate(DateTime date) {
    DateTime val = changeTimestamp.value;
    val = DateTime(
      date.year,
      date.month,
      date.day,
      val.hour,
      val.minute,
      val.second,
    );
    changeTimestamp(val);
  }

  void changeTime(TimeOfDay? time) {
    if (time == null) {
      return;
    }
    DateTime val = changeTimestamp.value;
    val = DateTime(val.year, val.month, val.day, time.hour, time.minute);
    changeTimestamp(val);
  }

  String remark;

  double productAmount(Product product) {
    return transactionParts
        .where((element) => element.product?.id == product.id)
        .fold(
          0.0,
          (previousValue, element) => previousValue + (element.amount ?? 0.0),
        );
  }

  double get sum => transactionParts.fold(
    0.0,
    (previousValue, element) => previousValue + (element.value),
  );

  Future<Result<Transaction>> save() async {
    var res = await repository.createEntity();
    switch (res) {
      case Ok<Transaction>():
        var transaction = res.value;
        transaction.timestamp = changeTimestamp.value;
        transaction.remark = remark;
        transaction.transactionPartner = changePartner.value;

        return await repository.saveTransaction(
          transaction,
          content: transactionParts,
        );

      case Error<Transaction>():
        return res;
    }
  }

  void partnerSearchText(TextEditingValue val) {
    _partnerSearchText = val.text;
    partnerPagingController.refresh();
  }

  void partnerCityText(TextEditingValue val) {
    _partnerCityText = val.text;
    partnerPagingController.refresh();
  }

  void productNameText(TextEditingValue val) {
    _productNameText = val.text;
    productPagingController.refresh();
  }

  void productProducerText(TextEditingValue val) {
    _productProducerText = val.text;
    productPagingController.refresh();
  }

  void addPart(TransactionPartContent part) {
    transactionParts.insert(0, part);
    notifyListeners();
    if (scrollControllerParts.hasClients) {
      scrollControllerParts.animateTo(
        scrollControllerParts.position.minScrollExtent,
        duration: Durations.long4,
        curve: Curves.ease,
      );
    }
  }

  void addProductDetails(
    BuildContext context,
    Product? product,
    double? value,
  ) {
    final part = TransactionPartContent(
      product: product,
      amount: 1,
      value: value ?? 0.0,
    );
    addPart(part);
    partDetailsDialog(context, part);
  }

  void addTextPart(BuildContext context) {
    final part = TransactionPartContent();
    addPart(part);
    partDetailsDialog(context, part);
  }

  void partDetailsDialog(BuildContext context, TransactionPartContent part) {
    showDialog(
      context: context,
      builder: (context) {
        return TransactionCapturePartDetailsDialog(part: part);
      },
    ).then((a) => notifyListeners());
  }

  void addProduct(Product product, double? value) {
    if (transactionParts.any((element) => element.product?.id == product.id)) {
      final tp = transactionParts.firstWhere(
        (element) => element.product?.id == product.id,
      );
      if (tp.amount == null) {
        tp.amount = 1.0;
        tp.value = value ?? 0.0;
      } else {
        tp.value = (tp.value / tp.amount!) * (tp.amount! + 1.0);
        tp.amount = tp.amount! + 1.0;
      }
      notifyListeners();
    } else {
      addPart(
        TransactionPartContent(
          product: product,
          purpose: "",
          amount: 1,
          value: value ?? 0.0,
        ),
      );
    }
  }

  void createProduct(BuildContext context) async {
    ProductDetailsViewmodel vm = ProductDetailsViewmodel(
      productRepository: context.read(),
    );
    vm.createEntity.execute();

    var p = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PopScope(
          canPop: false,
          onPopInvokedWithResult: (didPop, result) {
            if (didPop) return;
            Navigator.pop(context, vm.entity);
          },
          child: ProductDetails(viewmodel: vm),
        ),
      ),
    );
    if (p != null && p is Product && context.mounted) {
      addProductDetails(context, p, null);
    }
  }

  void removePart(TransactionPartContent part) {
    transactionParts.remove(part);
    notifyListeners();
  }
}

class TransactionCapturePartDetailsDialog extends StatefulWidget {
  const TransactionCapturePartDetailsDialog({super.key, required this.part});

  final TransactionPartContent part;

  @override
  State<TransactionCapturePartDetailsDialog> createState() =>
      _TransactionCapturePartDetailsDialogState();
}

class _TransactionCapturePartDetailsDialogState
    extends State<TransactionCapturePartDetailsDialog> {
  late TextEditingController amountController = TextEditingController(
    text: widget.part.amount?.toReadableString(digits: 2),
  );
  late TextEditingController valuePerUnitController = TextEditingController();
  late TextEditingController depositPerUnitController = TextEditingController(
    text: deposit.toReadableString(digits: 2),
  );
  late TextEditingController valueTotalController = TextEditingController(
    text: widget.part.value.toReadableString(digits: 2),
  );

  double? valuePerUnit;
  double get deposit => widget.part.product?.deposit ?? 0.0;

  @override
  void initState() {
    calcPerUnit();
    super.initState();
  }

  void calcPerUnit() {
    if (widget.part.amount != null) {
      valuePerUnit = widget.part.value / widget.part.amount!;
      valuePerUnit = valuePerUnit! - deposit * valuePerUnit!.sign;
    }
    valuePerUnitController.text =
        valuePerUnit?.toReadableString(digits: 2) ?? "";
  }

  void calcTotal() {
    if (valuePerUnit != null && widget.part.amount != null) {
      widget.part.value =
          (valuePerUnit! + deposit * valuePerUnit!.sign) * widget.part.amount!;
    }
    valueTotalController.text = widget.part.value.toReadableString(digits: 2);
  }

  void setAmount(double? amount) {
    if (amount == null) {
      amountController.clear();
      setState(() => widget.part.amount = null);
    } else {
      setState(() {
        widget.part.amount = amount;

        calcTotal();
      });
    }
  }

  void setValuePerUnit(double? value) {
    valuePerUnit = value;
    calcTotal();
  }

  void setDeposit(double? value) {
    calcPerUnit();
  }

  void setValueTotal(double value) {
    widget.part.value = value;
    calcPerUnit();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: 8.0,
        children: [
          if (widget.part.product != null)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.network(
                height: 70,
                fit: BoxFit.contain,
                widget.part.product!.imageLink,
                errorBuilder: (context, error, stackTrace) =>
                    Icon(widget.part.product!.iconData),
              ),
            ),
          ProductPicker(
            label: "Produkt",
            repository: context.read(),
            onSelect: (l) => setState(() {
              widget.part.product = l;
              depositPerUnitController.text = deposit.toReadableString(
                digits: 2,
              );
              setDeposit(deposit);
            }),
            initialValue: widget.part.product,
          ),
          TextFormField(
            initialValue: widget.part.purpose,
            validator: (value) => value != null && value.length <= 127
                ? null
                : "Max. 127 Zeichen",
            decoration: InputDecoration(labelText: "Inhalt"),
            onChanged: (value) {
              widget.part.purpose = value;
            },
          ),
          Row(
            spacing: Dimens.hgap,
            children: [
              Expanded(
                child: TextFormField(
                  controller: amountController,
                  keyboardType: TextInputType.number,
                  validator: (value) =>
                      value == null || double.tryParse(value) != null
                      ? null
                      : "Ungültige Zahl",
                  decoration: InputDecoration(
                    labelText: "Menge",
                    suffixIcon: widget.part.amount != null
                        ? IconButton(
                            onPressed: () {
                              setAmount(null);
                            },
                            icon: Icon(Icons.clear),
                          )
                        : null,
                  ),
                  onChanged: (value) {
                    var v = double.tryParse(value);
                    if (v != null) {
                      setAmount(v);
                    }
                  },
                ),
              ),
              Expanded(
                child: TextFormField(
                  controller: valuePerUnitController,
                  keyboardType: TextInputType.number,
                  validator: (value) =>
                      value == null ||
                          value.isEmpty ||
                          double.tryParse(value) != null
                      ? null
                      : "Ungültige Zahl",
                  decoration: InputDecoration(labelText: "Wert pro Einheit"),
                  enabled:
                      widget.part.product != null && widget.part.amount != null,
                  onChanged: (value) {
                    var v = double.tryParse(value);
                    if (v != null) {
                      setValuePerUnit(v);
                    }
                  },
                ),
              ),
            ],
          ),
          Row(
            spacing: Dimens.hgap,
            children: [
              Expanded(
                child: TextFormField(
                  controller: depositPerUnitController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(labelText: "Pfand pro Einheit"),
                  validator: (value) =>
                      value == null ||
                          value.isEmpty ||
                          double.tryParse(value) != null
                      ? null
                      : "Ungültige Zahl",
                  enabled: false,
                ),
              ),
              Expanded(
                child: TextFormField(
                  controller: valueTotalController,
                  keyboardType: TextInputType.number,
                  validator: (value) =>
                      value == null ||
                          value.isEmpty ||
                          double.tryParse(value) != null
                      ? null
                      : "Ungültige Zahl",
                  decoration: InputDecoration(labelText: "Wert gesamt"),
                  onChanged: (value) {
                    var v = double.tryParse(value);
                    if (v != null) {
                      setValueTotal(v);
                    }
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
