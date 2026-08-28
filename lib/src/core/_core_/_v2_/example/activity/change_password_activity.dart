import '../../../../../../flutter_artist.dart';
import '../flow/change_password_flow.dart';

class ChangePasswordActivity extends Activity {
  @override
  ActivityStructure defineActivityStructure() {
    return ActivityStructure(
      flows: [
        ChangePasswordFlow(name: ChangePasswordFlow.flowName),
      ],
      tasks: [],
    );
  }

  ChangePasswordFlow findChangePasswordFlow() {
    return findFlow(ChangePasswordFlow.flowName) as ChangePasswordFlow;
  }
}
