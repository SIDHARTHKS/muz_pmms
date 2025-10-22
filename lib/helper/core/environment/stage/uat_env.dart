import '../env_config.dart';

class UatEnvironment extends EnvironmentConfig {
  UatEnvironment()
      : super(
          baseApiurl: 'http://202.164.153.62:8367/mzmobileapp',
          // baseApiurl: 'http://202.164.153.62:8697/mzmobileapp', //live
          title: 'MIS UAT',
          enableLogs: true,
          enableNetworkImages: true,
          version: '1.0.1',
          appUpdateDate: '02nd Sep 2024 01:07 PM',
          releaseDate: '02nd Sep 2024',
        );
}
