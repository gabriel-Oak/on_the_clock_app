import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:on_the_clock_app/pages/home/home_bloc.dart';
import 'package:on_the_clock_app/pages/home/home_event.dart';
import 'package:on_the_clock_app/pages/home/home_state.dart';

class HomeContent extends StatelessWidget {
  final TextEditingController loginController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  HomeContent({Key? key}) : super(key: key);

  _sendeRequest(BuildContext context, HomeState state) {
    if (_formKey.currentState!.validate() && state is Loaded) {
      BlocProvider.of<HomeBloc>(context).add(SendRequest(
        login: loginController.text,
        password: passwordController.text,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<HomeBloc, HomeState>(
      listener: (context, state) {
        if (state is Loaded) {
          loginController.text = state.login ?? '';
          passwordController.text = state.password ?? '';

          if (state.message != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message ?? '')),
            );
          }
        }
      },
      child: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) => Scaffold(
          appBar: AppBar(
            title: const Text('On THE Clock'),
          ),
          body: Center(
            child: state is Started
                ? const CircularProgressIndicator()
                : Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          TextFormField(
                            controller: loginController,
                            textInputAction: TextInputAction.next,
                            keyboardType: const TextInputType.numberWithOptions(
                                decimal: false),
                            decoration: const InputDecoration(
                              labelText: 'Login',
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) =>
                                value!.isNotEmpty ? null : 'Preencha seu login',
                          ),
                          Container(height: 16),
                          TextFormField(
                            controller: passwordController,
                            textInputAction: TextInputAction.done,
                            obscureText: true,
                            enableSuggestions: false,
                            autocorrect: false,
                            decoration: const InputDecoration(
                              labelText: 'Senha',
                              border: OutlineInputBorder(),
                            ),
                            onEditingComplete: () =>
                                _sendeRequest(context, state),
                            validator: (value) =>
                                value!.isNotEmpty ? null : 'Preencha sua senha',
                          ),
                          Container(height: 16),
                          Text(
                            state is Loaded && state.lastClock != null
                                ? 'Ultimo ponto batido: ${state.lastClock}'
                                : '',
                            style: const TextStyle(color: Colors.black54),
                          ),
                          Container(height: 16),
                          FloatingActionButton(
                            tooltip: 'Bater ponto',
                            onPressed: () => _sendeRequest(context, state),
                            backgroundColor: state is Processing
                                ? Colors.grey[300]
                                : Theme.of(context).primaryColor,
                            child: state is Processing
                                ? const CircularProgressIndicator()
                                : const Icon(Icons.done),
                          ),
                        ],
                      ),
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
