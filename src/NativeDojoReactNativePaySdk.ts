import { TurboModuleRegistry, type TurboModule } from 'react-native';

export enum ResultCode {
  successful = 0,
  authorizing = 3,
  referred = 4,
  declined = 5,
  duplicateTransaction = 20,
  failed = 30,
  expired = 40,
  waitingPreExecute = 99,
  invalidRequest = 400,
  issueWithAccessToken = 401,
  noAccessTokenSupplied = 404,
  internalServerError = 500,
  sdkInternalError = 7770,
  userClosedWithoutPaying = 7780,
}

export type PaymentDetails = {
  /**
   * Payment intent ID
   */
  intentId: string;

  /**
   * Customer secret token - for managing saved cards
   */
  customerSecret?: string;

  /**
   * Is production - sets up SDK appropriately
   */
  isProduction?: boolean;

  /**
   * Apple pay merchant ID
   *
   * iOS only
   */
  applePayMerchantId?: string;

  /**
   * Should the payment UI use dark theme
   *
   * @default false
   * iOS only
   */
  darkTheme?: boolean;

  /**
   * Should the payment UI use light theme
   *
   * @default false
   * Android only
   */
  forceLightMode?: boolean;

  /**
   * Google Pay merchant ID
   *
   * Android only
   */
  gPayMerchantId?: string;

  /**
   * Dojo location merchant ID
   *
   * Android only
   */
  gPayGatewayMerchantId?: string;

  /**
   * Dojo location merchant name
   *
   * Android only
   */
  gPayMerchantName?: string;

  /**
   * Show Dojo branding
   *
   * @default true
   */
  showBranding?: boolean;

  /**
   * ISO formatted datetime which represents a time after which
   * the user will not be allowed to complete the payment
   */
  mustCompleteBy?: string;

  /**
   * Additional legal text to show on the first checkout page
   */
  additionalLegalText?: string;

  /**
   * Additional cutomisation for titles
   */
  customCardDetailsNavigationTitle?: string;
  customResultScreenTitleSuccess?: string;
  customResultScreenTitleFail?: string;
  customResultScreenOrderIdText?: string;
  customResultScreenMainTextSuccess?: string;
  customResultScreenMainTextFail?: string;
  customResultScreenAdditionalTextSuccess?: string;
  customResultScreenAdditionalTextFail?: string;

  /**
   * Background dim colour in hex, default is #000000
   * Use backdropViewAlpha to set alpha, default is 0.3
   */
  backdropViewColor?: string;

  /**
   * Background dim colour alpha, default is 0.3
   * Use backdropViewColor to set colour, default is #000000
   */
  backdropViewAlpha?: number;
};

export interface Spec extends TurboModule {
  startPaymentFlow(details: PaymentDetails): Promise<number>;
  startSetupFlow(details: PaymentDetails): Promise<number>;
}

export default TurboModuleRegistry.getEnforcing<Spec>('DojoReactNativePaySdk');
