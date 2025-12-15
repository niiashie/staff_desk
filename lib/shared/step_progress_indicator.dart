import 'package:flutter/material.dart';

class StepProgressIndicator extends StatelessWidget {
  final int numberOfSteps;
  final List<String> stepLabels;
  final int currentStep;
  final void Function(int stepNumber)? onStepTapped;

  const StepProgressIndicator({
    Key? key,
    required this.numberOfSteps,
    required this.stepLabels,
    this.currentStep = 1,
    this.onStepTapped,
  }) : assert(numberOfSteps > 0, 'Number of steps must be greater than 0'),
       assert(currentStep > 0, 'Current step must be greater than 0'),
       super(key: key);

  @override
  Widget build(BuildContext context) {
    assert(
      stepLabels.length == numberOfSteps,
      'Step labels length must match number of steps',
    );

    final theme = Theme.of(context);
    final primaryColor = theme.primaryColor;

    return LayoutBuilder(
      builder: (context, constraints) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Steps row
            SizedBox(
              height: 50,
              child: Row(
                children: List.generate(numberOfSteps * 2 - 1, (index) {
                  if (index.isEven) {
                    // Circle container
                    final stepNumber = (index ~/ 2) + 1;
                    final isSelected = stepNumber <= currentStep;
                    return _buildStepCircle(
                      stepNumber,
                      isSelected,
                      primaryColor,
                    );
                  } else {
                    // Progress bar
                    final stepNumber = (index ~/ 2) + 1;
                    final isCompleted = stepNumber < currentStep;
                    return _buildProgressBar(isCompleted, primaryColor);
                  }
                }),
              ),
            ),
            const SizedBox(height: 8),
            // Labels row
            // Row(
            //   children: List.generate(numberOfSteps * 2 - 1, (index) {
            //     if (index.isEven) {
            //       final stepIndex = index ~/ 2;
            //       return _buildStepLabel(stepLabels[stepIndex]);
            //     } else {
            //       return const Expanded(child: SizedBox());
            //     }
            //   }),
            // ),
          ],
        );
      },
    );
  }

  Widget _buildStepCircle(int stepNumber, bool isSelected, Color primaryColor) {
    final circle = Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isSelected ? primaryColor : Colors.grey.shade300,
        border: Border.all(
          color: isSelected ? primaryColor : Colors.grey.shade400,
          width: 2,
        ),
      ),
      child: Center(
        child: Text(
          '$stepNumber',
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.grey.shade600,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
    );

    if (onStepTapped != null) {
      return GestureDetector(
        onTap: () => onStepTapped!(stepNumber),
        child: circle,
      );
    }

    return circle;
  }

  Widget _buildProgressBar(bool isCompleted, Color primaryColor) {
    return Expanded(
      child: Container(
        height: 6,
        color: isCompleted ? primaryColor : Colors.grey.shade300,
      ),
    );
  }

  Widget _buildStepLabel(String label) {
    return Expanded(
      child: Text(
        label,
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 11),
        maxLines: 1,
        overflow: TextOverflow.visible,
      ),
    );
  }
}
