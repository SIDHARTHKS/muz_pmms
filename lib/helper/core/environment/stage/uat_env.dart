import '../env_config.dart';

class UatEnvironment extends EnvironmentConfig {
  UatEnvironment()
      : super(
          // baseApiurl: 'http://202.164.153.62:8398/mzmobileapp', //uat
          baseApiurl: 'http://192.168.0.12:7899/mzmobileapp', //live
          title: 'MIS UAT',
          enableLogs: true,
          enableNetworkImages: true,
          version: '1.0.1',
          appUpdateDate: '28rd Jan 2025 3:00 PM',
          releaseDate: '28rd Jan 2025',
        );
}
