import React, { type FC } from 'react';
import { StatusBar } from 'react-native';
import {
  createStackNavigator,
  type StackNavigationOptions,
} from '@react-navigation/stack';
import { NavigationContainer } from '@react-navigation/native';
import { NavigationRoute, type RootStackParamList } from './routes';
import DojoSdk from './screens/DojoSdk';
import Settings from './screens/Settings';
import SettingsProvider from './settings/SettingsProvider';

const StackNavigator = createStackNavigator<RootStackParamList>();

const dojoSdkScreenOptions: StackNavigationOptions = {
  title: 'Dojo Sdk',
};

const settingsScreenOptions: StackNavigationOptions = {
  title: 'Settings',
};

const App: FC = () => {
  return (
    <SettingsProvider>
      <StatusBar barStyle="default" />
      <NavigationContainer>
        <StackNavigator.Navigator>
          <StackNavigator.Screen
            name={NavigationRoute.DojoSdk}
            component={DojoSdk}
            options={dojoSdkScreenOptions}
          />
          <StackNavigator.Screen
            name={NavigationRoute.Settings}
            component={Settings}
            options={settingsScreenOptions}
          />
        </StackNavigator.Navigator>
      </NavigationContainer>
    </SettingsProvider>
  );
};

export default App;
