// * Testing & Mocking Libs
// ignore_for_file: must_be_immutable

import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:primala/app/modules/p2p_collaborator_pool/data/data.dart';
import 'package:primala/app/modules/p2p_collaborator_pool/domain/domain.dart';
import 'package:primala/app/modules/p2p_collaborator_pool/presentation/presentation.dart';
import 'package:speech_to_text/speech_to_text.dart';

class MP2PCollaboratorPoolRemoteSourceImpl extends Mock
    implements P2PCollaboratorPoolRemoteSourceImpl {}

class MP2PCollaboratorPoolContract extends Mock
    implements P2PCollaboratorPoolContract {}

class MInitiateSpeechToText extends Mock implements InitiateSpeechToText {}

class MOnSpeechResult extends Mock implements OnSpeechResult {}

class MEnterCollaboratorPool extends Mock implements EnterCollaboratorPool {}

class MStartListening extends Mock implements StartListening {}

class MStopListening extends Mock implements StopListening {}

class MValidateQuery extends Mock implements ValidateQuery {}

class MExitCollaboratorPool extends Mock implements ExitCollaboratorPool {}

class MOnSpeechResultStore extends Mock implements OnSpeechResultStore {}

class MSpeechToText extends Mock implements SpeechToText {}

class MCancelCollaboratorStreamGetterStore extends Mock
    implements CancelCollaboratorStreamGetterStore {}

class MEnterCollaboratorPoolGetterStore extends Mock
    implements EnterCollaboratorPoolGetterStore {}

class MExitCollaboratorPoolGetterStore extends Mock
    implements ExitCollaboratorPoolGetterStore {}

class MGetCollaboratorSearchStatusGetterStore extends Mock
    implements GetCollaboratorSearchStatusGetterStore {}

class MInitiateSpeechToTextGetterStore extends Mock
    implements InitiateSpeechToTextGetterStore {}

class MStartListeningGetterStore extends Mock
    implements StartListeningGetterStore {}

class MStopListeningGetterStore extends Mock
    implements StopListeningGetterStore {}

class MValidateQueryGetterStore extends Mock
    implements ValidateQueryGetterStore {}

@GenerateMocks([
  MP2PCollaboratorPoolRemoteSourceImpl,
  MEnterCollaboratorPool,
  MSpeechToText,
  MInitiateSpeechToText,
  MOnSpeechResult,
  MStartListening,
  MExitCollaboratorPool,
  MStopListening,
  MValidateQuery,
  MP2PCollaboratorPoolContract,
  MOnSpeechResultStore,
  MCancelCollaboratorStreamGetterStore,
  MEnterCollaboratorPoolGetterStore,
  MExitCollaboratorPoolGetterStore,
  MGetCollaboratorSearchStatusGetterStore,
  MInitiateSpeechToTextGetterStore,
  MStartListeningGetterStore,
  MStopListeningGetterStore,
  MValidateQueryGetterStore,
])
@GenerateNiceMocks([
  MockSpec<P2PCollaboratorPoolRemoteSource>(),
])
void main() {}
