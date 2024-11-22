import React, { useState, type FC } from 'react';
import { Alert, StyleSheet, Text, TextInput, View } from 'react-native';
import type { StackScreenProps } from '@react-navigation/stack';
import {
  startPaymentFlow,
  startSetupFlow,
} from '@dojo-engineering/react-native-pay-sdk';
import useSettings from '../settings/useSettings';
import { NavigationRoute, type RootStackParamList } from '../routes';
import Button from '../components/Button';

type DojoSdkProps = StackScreenProps<
  RootStackParamList,
  NavigationRoute.DojoSdk
>;

const DojoSdk: FC<DojoSdkProps> = (props) => {
  const { navigation } = props;
  const [intentId, setIntentId] = useState('');

  const { walletPaymentsConfig, theme } = useSettings();

  const goToSettings = () => {
    navigation.navigate(NavigationRoute.Settings);
  };

  const handleSetupIntentPress = () => {
    startSetupFlow({
      intentId,
      darkTheme: theme === 'dark',
      forceLightMode: theme === 'light',
    }).then((result) => {
      Alert.alert(`Result: ${result}`);
    });
  };

  const handlePaymentIntentPress = () => {
    startPaymentFlow({
      intentId,
      darkTheme: theme === 'dark',
      forceLightMode: theme === 'light',
      applePayMerchantId: walletPaymentsConfig?.applePayMerchantId,
      gPayMerchantId: walletPaymentsConfig?.gPayMerchantId,
      gPayGatewayMerchantId: walletPaymentsConfig?.gPayGatewayMerchantId,
    }).then((result) => {
      Alert.alert(`Result: ` + result);
    });
  };

  return (
    <View style={styles.mainContainer}>
      <TextInput
        style={styles.input}
        onChangeText={setIntentId}
        placeholder="IntentId"
      />
      <View style={styles.leftContainer}>
        <Text style={styles.settingsLabels}>
          WalletPayments: {walletPaymentsConfig ? 'Enabled' : 'Disabled'}
        </Text>
        <Text style={styles.settingsLabels}>
          Theme: {theme === 'light' ? 'Light' : 'Dark'}
        </Text>
      </View>
      <View style={styles.rightContainer}>
        <Button text="Settings" onPress={goToSettings} />
      </View>
      <View style={styles.bottomContainer}>
        <View style={styles.buttonWrapper}>
          <Button
            text="Start Setup Flow"
            style={styles.startFlowButton}
            onPress={handleSetupIntentPress}
          />
        </View>
        <View style={styles.buttonWrapper}>
          <Button
            text="Start Payment Flow"
            style={styles.startFlowButton}
            onPress={handlePaymentIntentPress}
          />
        </View>
      </View>
    </View>
  );
};

const styles = StyleSheet.create({
  mainContainer: {
    flex: 1,
    backgroundColor: '#fff',
    alignItems: 'center',
  },
  leftContainer: {
    padding: 15,
    alignSelf: 'flex-start',
  },
  rightContainer: {
    padding: 10,
    alignSelf: 'flex-end',
    marginTop: -60,
  },
  bottomContainer: {
    padding: 10,
    marginTop: 80,
  },
  input: {
    borderWidth: 0.8,
    width: 200,
    marginTop: 280,
    fontSize: 20,
    padding: 10,
  },
  settingsLabels: {
    fontSize: 15,
  },
  buttonWrapper: {
    marginVertical: 8,
  },
  startFlowButton: {
    backgroundColor: '#008275',
  },
});

export default DojoSdk;
