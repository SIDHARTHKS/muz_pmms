import '../env_config.dart';

class UatEnvironment extends EnvironmentConfig {
  UatEnvironment()
      : super(
          baseApiurl: 'http://202.164.152.219:8366/mzmobileapp',
          title: 'MIS UAT',
          enableLogs: true,
          enableNetworkImages: true,
          appUpdateDate: '02nd Sep 2024 01:07 PM',
          version: 'v1.0.1 -uat',
          releaseDate: '02nd Sep 2024',
        );
}
