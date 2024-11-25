import React, { type FC } from 'react';
import {
  StyleSheet,
  Text,
  TouchableOpacity,
  type StyleProp,
  type TextStyle,
  type TouchableOpacityProps,
} from 'react-native';

type ButtonProps = Omit<TouchableOpacityProps, 'children'> & {
  text: string;
  textStyle?: StyleProp<TextStyle>;
};

const Button: FC<ButtonProps> = (props) => {
  const { text, style, textStyle, ...nativeProps } = props;

  return (
    <TouchableOpacity {...nativeProps} style={[styles.button, style]}>
      <Text style={[styles.text, textStyle]}>{text}</Text>
    </TouchableOpacity>
  );
};

const styles = StyleSheet.create({
  button: {
    padding: 16,
    alignItems: 'center',
    justifyContent: 'center',
  },
  text: {
    color: 'white',
  },
});

export default Button;
