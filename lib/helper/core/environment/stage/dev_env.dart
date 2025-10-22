import '../env_config.dart';

class DevEnvironment extends EnvironmentConfig {
  DevEnvironment()
      : super(
          baseApiurl: 'http://202.164.153.62:8697/mzmobileapp', //live
          // baseApiurl: 'http://202.164.153.62:8367/mzmobileapp',
          title: 'MIS Dev',
          enableLogs: true,
          enableNetworkImages: true,
          version: '1.0.1',
          appUpdateDate: '3rd October 2025 09:00 AM',
          releaseDate: '3rd October 2025',
        );
}
