import * as React from 'react';

import { StyleSheet, View, Text, Button, TextInput } from 'react-native';
import { startPaymentFlow } from '@dojo-engineering/react-native-pay-sdk';

export default function App() {
  const [result, setResult] = React.useState<number | undefined>();
  const [token, setToken] = React.useState<string>('');

  const pay = () => {
    startPaymentFlow({
      intentId: token,
    }).then((res) => {
      setResult(res);
    });
  };

  return (
    <View style={styles.container}>
      <View style={styles.inputContainer}>
        <TextInput style={styles.input} onChangeText={setToken} value={token} />
      </View>
      <Button title="Pay" onPress={pay} />
      <Text>Result: {result}</Text>
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    alignItems: 'center',
    justifyContent: 'center',
    width: '100%',
  },
  inputContainer: {
    flexDirection: 'row',
    marginBottom: 20,
  },
  input: {
    height: 40,
    margin: 12,
    borderWidth: 1,
    padding: 10,
    flex: 1,
  },
});
