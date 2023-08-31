import 'package:dartz/dartz.dart';
import 'package:primala/app/core/error/failure.dart';
import 'package:primala/app/modules/home/domain/entities/entities.dart';
import 'package:primala/app/modules/p2p_collaborator_pool/domain/entities/entities.dart';
import 'package:primala/app/modules/p2p_purpose_session/domain/domain.dart';
import 'package:primala_backend/phrase_components.dart';

class DefaultEntities {
  static Either<Failure, NameCreationStatusEntity>
      get nameCreationStatusEntity =>
          const Right(NameCreationStatusEntity(isSent: false));
  static Either<Failure, CollaboratorPhraseEntity>
      get collaboratorPhraseEntity =>
          const Right(CollaboratorPhraseEntity(collaboratorPhrase: ''));
  static Either<Failure, ListeningStatusEntity> get listeningStatusEntity =>
      const Right(ListeningStatusEntity(isListening: false));
  static Either<Failure, SpeechToTextInitializerStatusEntity>
      get speechToTextInitializerStatusEntity =>
          const Right(SpeechToTextInitializerStatusEntity(isAllowed: false));
  static Either<Failure, CollaboratorPhraseValidationEntity>
      get collaboratorPhraseValidationEntity =>
          Right(CollaboratorPhraseValidationEntity(
              isValid: false, phraseIDs: defaultCollaboratorPhraseIDs));
  static Either<Failure, CollaboratorPoolEntryStatusEntity>
      get collaboratorPoolEntryStatusEntity =>
          const Right(CollaboratorPoolEntryStatusEntity(hasEntered: false));
  static Either<Failure, CollaboratorPoolExitStatusEntity>
      get collaboratorPoolExitStatusEntity =>
          const Right(CollaboratorPoolExitStatusEntity(hasLeft: false));
  static Either<Failure, CollaboratorStreamStatusEntity>
      get collaboratorStreamStatusEntity =>
          const Right(CollaboratorStreamStatusEntity(isSubscribed: false));
  static CollaboratorPhraseIDs get defaultCollaboratorPhraseIDs =>
      const CollaboratorPhraseIDs(adjectiveID: -1, nounID: -1);
  static Either<Failure, ChannelIdEntity> get defaultChannelIdEntity =>
      const Right(ChannelIdEntity(channelId: ''));
  static Either<Failure, AgoraCallTokenEntity> get defaultCallTokenEntity =>
      const Right(AgoraCallTokenEntity(returnedToken: ''));
  static Either<Failure, AgoraSdkStatusEntity>
      get defaultAgoraSdkStatusEntity =>
          const Right(AgoraSdkStatusEntity(isInstantiated: false));
}
