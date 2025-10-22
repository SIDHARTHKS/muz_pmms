import '../env_config.dart';

class ProdEnvironment extends EnvironmentConfig {
  ProdEnvironment()
      : super(
          baseApiurl: 'http://202.164.152.219:8366/mzmobileapp',
          title: 'MIS',
          enableLogs: false,
          enableNetworkImages: true,
          appUpdateDate: '15th July 2024 09:00 AM',
          version: 'v1.0.1',
          releaseDate: '15th July 2024',
        );
}
