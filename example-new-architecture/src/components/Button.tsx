import React, { type FC } from 'react';
import {
  StyleSheet,
  Text,
  TouchableOpacity,
  type TouchableOpacityProps,
} from 'react-native';

type ButtonProps = Omit<TouchableOpacityProps, 'children'> & {
  text: string;
};

const Button: FC<ButtonProps> = (props) => {
  const { text, style, ...nativeProps } = props;

  return (
    <TouchableOpacity {...nativeProps} style={[style, styles.button]}>
      <Text>{text}</Text>
    </TouchableOpacity>
  );
};

const styles = StyleSheet.create({
  button: {},
});

export default Button;
