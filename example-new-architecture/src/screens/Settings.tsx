import React, { type FC } from 'react';
import { Platform, StyleSheet, Text, View, Switch } from 'react-native';
import type { StackScreenProps } from '@react-navigation/stack';
import SegmentedControl from '@react-native-segmented-control/segmented-control';
import type { NavigationRoute, RootStackParamList } from '../routes';
import useSettings from '../settings/useSettings';

type SettingsProps = StackScreenProps<
  RootStackParamList,
  NavigationRoute.Settings
>;

const osPay = Platform.select({
  android: 'GPay',
  ios: 'ApplePay',
});

const Settings: FC<SettingsProps> = () => {
  const { toggleWalletPaymentsEnabled, walletPaymentsConfig, theme, setTheme } =
    useSettings();

  return (
    <View style={styles.mainContainer}>
      <View style={styles.viewFlexDirection}>
        <Text style={styles.label}>{osPay}</Text>
        <Switch
          style={styles.rightContainer}
          onValueChange={toggleWalletPaymentsEnabled}
          value={!!walletPaymentsConfig}
        />
      </View>
      <View style={styles.viewFlexDirection}>
        <Text style={styles.label}>Theme</Text>
        <View style={[styles.segmentContainer, styles.rightContainer]}>
          <SegmentedControl
            values={['Light', 'Dark']}
            onValueChange={(value) => {
              setTheme(value === 'Light' ? 'light' : 'dark');
            }}
            selectedIndex={theme === 'light' ? 0 : 1}
            // activeTabStyle={styles.activeTabStyle}
            tabStyle={styles.tabStyle}
            // tabTextStyle={styles.tabTextStyle}
          />
        </View>
      </View>
    </View>
  );
};

const styles = StyleSheet.create({
  viewFlexDirection: {
    flexDirection: 'row',
  },
  mainContainer: {
    paddingRight: 55,
    paddingLeft: 55,
    paddingTop: 15,
  },
  label: {
    marginLeft: -30,
    fontSize: 17,
    padding: 10,
    fontWeight: '500',
  },
  segmentContainer: {
    marginTop: 5,
    width: 150,
  },

  rightContainer: {
    position: 'absolute',
    top: 0,
    bottom: 0,
    right: 0,
    justifyContent: 'center',
  },

  activeTabStyle: {
    backgroundColor: '#008275',
    borderColor: 'white',
  },
  tabStyle: {
    backgroundColor: 'white',
    borderColor: 'white',
  },
  tabTextStyle: {
    color: '#008275',
  },
});

export default Settings;
