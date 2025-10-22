import '../env_config.dart';

class ProdEnvironment extends EnvironmentConfig {
  ProdEnvironment()
      : super(
          // baseApiurl: 'http://202.164.152.219:8391/mretailmobileapp',
          baseApiurl: 'http://202.164.153.62:8697/mzmobileapp', //live
          title: 'MIS',
          enableLogs: false,
          enableNetworkImages: true,
          version: '1.0.1',
          appUpdateDate: '3rd October 2025 09:00 AM',
          releaseDate: '3rd October 2025',
        );
}
