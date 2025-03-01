import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../models/budget.dart';
import '../services/budget_service.dart';
import '../services/category_service.dart';

class AddBudgetScreen extends StatefulWidget {
  final Budget? budget;

  const AddBudgetScreen({
    super.key,
    this.budget,
  });

  @override
  State<AddBudgetScreen> createState() => _AddBudgetScreenState();
}

class _AddBudgetScreenState extends State<AddBudgetScreen>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _amountController = TextEditingController();
  final _descriptionController = TextEditingController();

  late AnimationController _animationController;
  late Animation<double> _slideAnimation;
  late Animation<double> _fadeAnimation;

  String? _selectedCategoryId;
  BudgetPeriod _selectedPeriod = BudgetPeriod.monthly;
  bool _isLoading = false;
  bool _enableAlerts = true;
  double _alertThreshold = 80.0;

  @override
  void initState() {
    super.initState();

    // Initialize FinanceArcade animations
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _slideAnimation = Tween<double>(
      begin: 30.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));

    // Initialize form if editing budget
    if (widget.budget != null) {
      _nameController.text = widget.budget!.name;
      _amountController.text = widget.budget!.amount.toString();
      // Note: Removed description, enableAlerts, alertThreshold as they don't exist in Budget model
      _selectedCategoryId = widget.budget!.categoryId;
      _selectedPeriod = widget.budget!.period;
    }

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _nameController.dispose();
    _amountController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: _buildArcadeAppBar(),
      body: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return Transform.translate(
            offset: Offset(0, _slideAnimation.value),
            child: Opacity(
              opacity: _fadeAnimation.value,
              child: _buildForm(),
            ),
          );
        },
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: _buildSaveButton(),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildArcadeAppBar() {
    return AppBar(
      title: Text(
        widget.budget != null ? 'Edit Budget' : 'Add Budget',
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
      ),
      backgroundColor: Theme.of(context).colorScheme.surface,
      elevation: 0,
      actions: widget.budget != null
          ? [
              Container(
                margin: const EdgeInsets.only(right: 8),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.red.withOpacity(0.2),
                      Colors.red.withOpacity(0.1),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: IconButton(
                  icon: Icon(
                    Icons.delete_outline,
                    color: Colors.red[400],
                  ),
                  onPressed: _showDeleteDialog,
                  tooltip: 'Delete Budget',
                ),
              ),
            ]
          : null,
    );
  }

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Budget Name Field
            _buildNameCard(),
            const SizedBox(height: 16),

            // Budget Amount Field
            _buildAmountCard(),
            const SizedBox(height: 16),

            // Category Selection
            _buildCategoryCard(),
            const SizedBox(height: 16),

            // Budget Period
            _buildPeriodCard(),
            const SizedBox(height: 16),

            // Alert Settings
            _buildAlertCard(),
            const SizedBox(height: 16),

            // Description Field
            _buildDescriptionCard(),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  Widget _buildNameCard() {
    return Card(
      elevation: 8,
      shadowColor: Theme.of(context).colorScheme.primary.withOpacity(0.3),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            colors: [
              Theme.of(context).colorScheme.primary.withOpacity(0.1),
              Theme.of(context).colorScheme.primary.withOpacity(0.05),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Theme.of(context)
                          .colorScheme
                          .primary
                          .withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.label,
                      color: Theme.of(context).colorScheme.primary,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Budget Name',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  hintText: 'Enter budget name',
                  prefixIcon: Icon(Icons.edit,
                      color: Theme.of(context).colorScheme.primary),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide(
                      color: Theme.of(context).colorScheme.primary,
                      width: 2,
                    ),
                  ),
                  filled: true,
                  fillColor: Theme.of(context).colorScheme.surface,
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a budget name';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAmountCard() {
    return Card(
      elevation: 8,
      shadowColor: Colors.green.withOpacity(0.3),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            colors: [
              Colors.green.withOpacity(0.1),
              Colors.green.withOpacity(0.05),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.green.withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.account_balance_wallet,
                      color: Colors.green,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Budget Amount',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _amountController,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
                ],
                decoration: InputDecoration(
                  hintText: '0.00',
                  prefixText: '\K  ',
                  prefixIcon:
                      const Icon(Icons.attach_money, color: Colors.green),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(
                      color: Colors.green,
                      width: 2,
                    ),
                  ),
                  filled: true,
                  fillColor: Theme.of(context).colorScheme.surface,
                ),
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a budget amount';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter a valid amount';
                  }
                  if (double.parse(value) <= 0) {
                    return 'Amount must be greater than zero';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryCard() {
    return Card(
      elevation: 8,
      shadowColor: Colors.orange.withOpacity(0.3),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            colors: [
              Colors.orange.withOpacity(0.1),
              Colors.orange.withOpacity(0.05),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.orange.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.category,
                      color: Colors.orange,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Category (Optional)',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.orange,
                          ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Consumer<CategoryService>(
                builder: (context, categoryService, child) {
                  final categories = categoryService.expenseCategories;

                  return DropdownButtonFormField<String>(
                    value: _selectedCategoryId,
                    decoration: InputDecoration(
                      prefixIcon:
                          const Icon(Icons.folder, color: Colors.orange),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: const BorderSide(
                          color: Colors.orange,
                          width: 2,
                        ),
                      ),
                      filled: true,
                      fillColor: Theme.of(context).colorScheme.surface,
                    ),
                    hint: const Text('Select category (optional)'),
                    isExpanded: true,
                    items: [
                      const DropdownMenuItem<String>(
                        value: null,
                        child: Text('All Categories'),
                      ),
                      ...categories.map((category) {
                        return DropdownMenuItem<String>(
                          value: category.id,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 16,
                                height: 16,
                                decoration: BoxDecoration(
                                  color: category.color,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  category.name,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ],
                    onChanged: (value) {
                      setState(() {
                        _selectedCategoryId = value;
                      });
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPeriodCard() {
    return Card(
      elevation: 8,
      shadowColor: Colors.purple.withOpacity(0.3),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            colors: [
              Colors.purple.withOpacity(0.1),
              Colors.purple.withOpacity(0.05),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.purple.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.schedule,
                      color: Colors.purple,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Budget Period',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.purple,
                          ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: BudgetPeriod.values.map((period) {
                  return _buildPeriodButton(period);
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPeriodButton(BudgetPeriod period) {
    final isSelected = _selectedPeriod == period;
    final periodNames = {
      BudgetPeriod.weekly: 'Weekly',
      BudgetPeriod.monthly: 'Monthly',
      BudgetPeriod.yearly: 'Yearly',
    };

    return InkWell(
      onTap: () {
        HapticFeedback.lightImpact();
        setState(() {
          _selectedPeriod = period;
        });
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected ? Colors.purple : Colors.grey,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(12),
          color: isSelected ? Colors.purple.withOpacity(0.1) : null,
        ),
        child: Text(
          periodNames[period] ?? '',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: isSelected ? Colors.purple : Colors.grey,
          ),
        ),
      ),
    );
  }

  Widget _buildAlertCard() {
    return Card(
      elevation: 8,
      shadowColor: Colors.amber.withOpacity(0.3),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            colors: [
              Colors.amber.withOpacity(0.1),
              Colors.amber.withOpacity(0.05),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.amber.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.notifications,
                      color: Colors.amber,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Alert Settings',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.amber,
                          ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              SwitchListTile(
                title: const Text('Enable Budget Alerts'),
                subtitle:
                    const Text('Get notified when approaching budget limit'),
                value: _enableAlerts,
                onChanged: (value) {
                  setState(() {
                    _enableAlerts = value;
                  });
                },
                activeColor: Colors.amber,
              ),
              if (_enableAlerts) ...[
                const SizedBox(height: 16),
                Text(
                  'Alert Threshold: ${_alertThreshold.toInt()}%',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Colors.amber,
                        fontWeight: FontWeight.w600,
                      ),
                ),
                const SizedBox(height: 8),
                Slider(
                  value: _alertThreshold,
                  min: 50,
                  max: 95,
                  divisions: 9,
                  activeColor: Colors.amber,
                  onChanged: (value) {
                    setState(() {
                      _alertThreshold = value;
                    });
                  },
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDescriptionCard() {
    return Card(
      elevation: 8,
      shadowColor: Colors.blue.withOpacity(0.3),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            colors: [
              Colors.blue.withOpacity(0.1),
              Colors.blue.withOpacity(0.05),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.description,
                      color: Colors.blue,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Description (Optional)',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                maxLines: 3,
                maxLength: 200,
                decoration: InputDecoration(
                  hintText: 'Enter budget description',
                  prefixIcon: const Icon(Icons.notes, color: Colors.blue),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(
                      color: Colors.blue,
                      width: 2,
                    ),
                  ),
                  filled: true,
                  fillColor: Theme.of(context).colorScheme.surface,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSaveButton() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          colors: [
            Theme.of(context).colorScheme.primary,
            Theme.of(context).colorScheme.primary.withOpacity(0.8),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.4),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ElevatedButton.icon(
        onPressed: _isLoading ? null : _saveBudget,
        icon: _isLoading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : const Icon(Icons.save, size: 24),
        label: Text(
          _isLoading
              ? 'Saving...'
              : widget.budget != null
                  ? 'Update Budget'
                  : 'Save Budget',
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 18),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 0,
        ),
      ),
    );
  }

  Future<void> _saveBudget() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final budgetService = context.read<BudgetService>();

      if (widget.budget != null) {
        // Update existing budget
        final updatedBudget = widget.budget!.copyWith(
          name: _nameController.text.trim(),
          amount: double.parse(_amountController.text),
          categoryId: _selectedCategoryId ?? '',
          period: _selectedPeriod,
        );
        await budgetService.updateBudget(updatedBudget);
      } else {
        // Create new budget
        final now = DateTime.now();
        final startDate = DateTime(now.year, now.month, now.day);
        DateTime endDate;
        switch (_selectedPeriod) {
          case BudgetPeriod.weekly:
            endDate = startDate.add(const Duration(days: 6));
            break;
          case BudgetPeriod.monthly:
            endDate =
                DateTime(startDate.year, startDate.month + 1, startDate.day)
                    .subtract(const Duration(days: 1));
            break;
          case BudgetPeriod.yearly:
            endDate =
                DateTime(startDate.year + 1, startDate.month, startDate.day)
                    .subtract(const Duration(days: 1));
            break;
        }
        final newBudget = Budget(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          name: _nameController.text.trim(),
          amount: double.parse(_amountController.text),
          categoryId: _selectedCategoryId ?? '',
          period: _selectedPeriod,
          createdDate: now,
          startDate: startDate,
          endDate: endDate,
        );
        await budgetService.addBudget(newBudget);
      }

      HapticFeedback.mediumImpact();

      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.check_circle, color: Colors.white),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    widget.budget != null
                        ? 'Budget updated successfully!'
                        : 'Budget created successfully!',
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.green,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            margin: const EdgeInsets.all(16),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.error, color: Colors.white),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Error saving budget: $e',
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            margin: const EdgeInsets.all(16),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _showDeleteDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).colorScheme.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Row(
          children: [
            Icon(Icons.warning_amber, color: Colors.red[400], size: 28),
            const SizedBox(width: 12),
            const Expanded(
              child: Text(
                'Delete Budget',
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        content: const Text(
          'Are you sure you want to delete this budget? This action cannot be undone.',
          style: TextStyle(fontSize: 16),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: TextStyle(color: Theme.of(context).colorScheme.primary),
            ),
          ),
          ElevatedButton(
            onPressed: _deleteBudget,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteBudget() async {
    try {
      Navigator.pop(context); // Close dialog

      final budgetService = context.read<BudgetService>();
      await budgetService.deleteBudget(widget.budget!.id);

      HapticFeedback.mediumImpact();

      if (mounted) {
        Navigator.pop(context); // Close screen
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Row(
              children: [
                Icon(Icons.check_circle, color: Colors.white),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Budget deleted successfully!',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.green,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            margin: const EdgeInsets.all(16),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.error, color: Colors.white),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Error deleting budget: $e',
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            margin: const EdgeInsets.all(16),
          ),
        );
      }
    }
  }
}
// Commit 24: 2025-02-08T19:46:35
// Commit 89: 2025-02-27T23:07:42
// Commit 102: 2025-03-03T19:17:51
// Commit 119: 2025-03-08T20:23:17
// Commit 1: 2025-02-02T00:38:44
// Commit 75: 2025-02-23T20:35:51
// Commit 129: 2025-03-11T19:06:16
// Commit 181: 2025-03-27T03:06:32
// Commit 5: 2025-02-03T05:01:21
// Commit 35: 2025-02-12T01:40:36
// Commit 36: 2025-02-12T07:50:20
// Commit 38: 2025-02-12T22:24:24
// Commit 86: 2025-02-27T02:30:19
// Commit 92: 2025-02-28T20:43:10
// Commit 99: 2025-03-02T21:50:27
// Commit 105: 2025-03-04T16:34:37
// Commit 118: 2025-03-08T12:57:56
// Commit 154: 2025-03-19T03:41:28
// Commit 192: 2025-03-30T08:27:54
// Commit 195: 2025-03-31T06:03:51
// Commit 40: 2025-02-13T12:59:38
// Commit 55: 2025-02-17T22:58:57
// Commit 79: 2025-02-25T01:08:16
// Commit 97: 2025-03-02T08:24:32
// Commit 174: 2025-03-25T01:32:23
// Commit 11: 2025-02-04T23:03:55
// Commit 26: 2025-02-09T09:54:24
// Commit 27: 2025-02-09T16:28:40
// Commit 29: 2025-02-10T06:33:55
// Commit 39: 2025-02-13T05:52:02
// Commit 48: 2025-02-15T21:04:08
// Commit 71: 2025-02-22T16:14:52
// Commit 97: 2025-03-02T08:21:04
// Commit 117: 2025-03-08T05:59:39
// Commit 147: 2025-03-17T02:18:08
// Commit 157: 2025-03-20T01:04:54
// Commit 183: 2025-03-27T17:22:53
// Commit 197: 2025-03-31T19:53:20
// Commit 5: 2025-02-03T05:02:15
// Commit 32: 2025-02-11T04:00:02
// Commit 49: 2025-02-16T03:54:31
// Commit 50: 2025-02-16T11:42:52
// Commit 60: 2025-02-19T10:34:22
// Commit 70: 2025-02-22T08:48:01
// Commit 90: 2025-02-28T07:00:25
// Commit 127: 2025-03-11T04:41:31
// Commit 141: 2025-03-15T07:34:00
// Commit 153: 2025-03-18T20:44:31
// Commit 179: 2025-03-26T13:01:44
// Commit 31: 2025-02-10T20:37:50
// Commit 38: 2025-02-12T22:33:18
// Commit 44: 2025-02-14T16:46:41
// Commit 64: 2025-02-20T14:24:19
// Commit 89: 2025-02-27T23:05:24
// Commit 95: 2025-03-01T17:52:45
