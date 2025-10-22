import '../env_config.dart';

class DevEnvironment extends EnvironmentConfig {
  DevEnvironment()
      : super(
          baseApiurl: 'http://202.164.152.219:8366/mzmobileapp',
          title: 'MIS Dev',
          enableLogs: true,
          enableNetworkImages: true,
          appUpdateDate: '15th July 2024 09:00 AM',
          version: 'v1.0.1 -dev',
          releaseDate: '15th July 2024',
        );
}
