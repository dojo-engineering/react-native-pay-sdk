import React from 'react';
import { createStackNavigator } from '@react-navigation/stack';
import { NavigationContainer } from '@react-navigation/native';
import FirstPage from './FirstPage';
import SettingsPage from './SettingsPage';
import { SwitchProvider } from './SwitchContext';

const Stack = createStackNavigator();
export default function App() {
  return (
    <SwitchProvider>
      <NavigationContainer>
        <Stack.Navigator>
          <Stack.Screen name="Dojo SDK" component={FirstPage} />
          <Stack.Screen name="Settings" component={SettingsPage} />
        </Stack.Navigator>
      </NavigationContainer>
    </SwitchProvider>
  );
}
