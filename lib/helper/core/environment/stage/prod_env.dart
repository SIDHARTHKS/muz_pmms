import '../env_config.dart';

class ProdEnvironment extends EnvironmentConfig {
  ProdEnvironment()
      : super(
          // baseApiurl: 'http://202.164.153.62:7899/mzmobileapp', //live
          baseApiurl: 'http://202.164.153.62:8398/mzmobileapp', //uat
          title: 'PMMS',
          enableLogs: false,
          enableNetworkImages: true,
          version: '1.0.1',
          appUpdateDate: '28rd Jan 2025 3:00 PM',
          releaseDate: '28rd Jan 2025',
        );
}
