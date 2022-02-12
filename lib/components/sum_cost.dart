import 'package:hikkoshi_cost_manager/model/entity/costs.dart';

int sumCost(List<Cost> costs, CostKind costKind) {
  int sum = 0;
  costs.forEach((cost) {
    if (costKind == CostKind.budgetCost) {
      if (cost.budgetCost != null) {
        sum += cost.budgetCost!;
      }
    } else {
      if (cost.actualCost != null) {
        sum += cost.actualCost!;
      }
    }
  });
  return sum;
}
