import { NativeModules, Platform } from 'react-native';
import { type PaymentDetails, ResultCode } from './NativeDojoReactNativePaySdk';

const LINKING_ERROR =
  `The package '@dojo-engineering/react-native-pay-sdk' doesn't seem to be linked. Make sure: \n\n` +
  Platform.select({ ios: "- You have run 'pod install'\n", default: '' }) +
  '- You rebuilt the app after installing the package\n' +
  '- You are not using Expo Go\n';

// @ts-expect-error
const isTurboModuleEnabled = global.__turboModuleProxy != null;

const DojoReactNativePaySdkModule = isTurboModuleEnabled
  ? require('./NativeDojoReactNativePaySdk').default
  : NativeModules.DojoReactNativePaySdk;

const DojoReactNativePaySdk = DojoReactNativePaySdkModule
  ? DojoReactNativePaySdkModule
  : new Proxy(
      {},
      {
        get() {
          throw new Error(LINKING_ERROR);
        },
      }
    );

export function startPaymentFlow(details: PaymentDetails): Promise<ResultCode> {
  return DojoReactNativePaySdk.startPaymentFlow(details);
}

export function startSetupFlow(details: PaymentDetails): Promise<ResultCode> {
  return DojoReactNativePaySdk.startSetupFlow(details);
}

export { type PaymentDetails, ResultCode };
