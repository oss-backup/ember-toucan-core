/* eslint-disable no-undef -- Until https://github.com/ember-cli/eslint-plugin-ember/issues/1747 is resolved... */
/* eslint-disable simple-import-sort/imports,padding-line-between-statements,decorator-position/decorator-position -- Can't fix these manually, without --fix working in .gts */

import { click, render } from '@ember/test-helpers';
import { module, test } from 'qunit';

import RadioGroupField from '@crowdstrike/ember-toucan-core/components/form/radio-group-field';
import { setupRenderingTest } from 'test-app/tests/helpers';

module('Integration | Component | RadioGroupField', function (hooks) {
  setupRenderingTest(hooks);

  test('it renders', async function (assert) {
    await render(<template>
      <RadioGroupField @label="Label" @name="group" data-group-field />
    </template>);

    assert.dom('[data-group-field]').exists();

    assert.dom('[data-label]').hasText('Label');
  });

  test('it renders yielded RadioFields', async function (assert) {
    await render(<template>
      <RadioGroupField @label="Label" @name="group" data-group-field as |group|>
        <group.RadioField @label="option-1" @value="option-1" data-radio-1 />
        <group.RadioField @label="option-2" @value="option-2" data-radio-2 />
      </RadioGroupField>
    </template>);

    assert.dom('[data-group-field]').exists();
    assert.dom('[data-radio-1]').exists();
    assert.dom('[data-radio-2]').exists();
  });

  test('it curries the `name` attribute to yielded RadioFields from the `@name` argument', async function (assert) {
    await render(<template>
      <RadioGroupField @label="Label" @name="group" data-group-field as |group|>
        <group.RadioField @label="option-1" @value="option-1" data-radio-1 />
        <group.RadioField @label="option-2" @value="option-2" data-radio-2 />
      </RadioGroupField>
    </template>);

    assert.dom('[data-radio-1]').hasAttribute('name', 'group');
    assert.dom('[data-radio-2]').hasAttribute('name', 'group');
  });

  test('it renders with a hint', async function (assert) {
    await render(<template>
      <RadioGroupField @label="Label" @name="group" @hint="Hint text" />
    </template>);

    assert.dom('[data-hint]').hasText('Hint text');
  });

  test('it renders with an error', async function (assert) {
    await render(<template>
      <RadioGroupField @label="Label" @name="group" @error="Error text" />
    </template>);

    assert.dom('[data-error]').hasText('Error text');
  });

  test('it default-checks the radio with the matching `@value`', async function (assert) {
    await render(<template>
      <RadioGroupField
        @label="Label"
        @name="group"
        @value="option-2"
        as |group|
      >
        <group.RadioField @label="option-1" @value="option-1" data-radio-1 />
        <group.RadioField @label="option-2" @value="option-2" data-radio-2 />
      </RadioGroupField>
    </template>);

    assert.dom('[data-radio-1]').isNotChecked();
    assert.dom('[data-radio-2]').isChecked();
  });

  test('it disables the fieldset and all child radios using `@isDisabled`', async function (assert) {
    await render(<template>
      <RadioGroupField
        @label="Label"
        @name="group"
        @isDisabled={{true}}
        data-group-field
        as |group|
      >
        <group.RadioField @label="option-1" @value="option-1" data-radio-1 />
        <group.RadioField @label="option-2" @value="option-2" data-radio-2 />
      </RadioGroupField>
    </template>);

    assert.dom('[data-group-field]').isDisabled();
    assert.dom('[data-radio-1]').isDisabled();
    assert.dom('[data-radio-2]').isDisabled();
  });

  test('it calls `@onChange` when a radio is clicked and can update `@value`', async function (assert) {
    assert.expect(8);

    let selectedValue = 'option-2';

    let handleChange = (value: string, e: Event | InputEvent) => {
      assert.strictEqual(value, 'option-1', 'Expected value to matched');
      assert.ok(e, 'Expected `e` to be available as the second argument');
      assert.ok(e.target, 'Expected direct access to target from `e`');
      assert.step('handleChange');

      selectedValue = value;
    };

    await render(<template>
      <RadioGroupField
        @label="Label"
        @name="group"
        @onChange={{handleChange}}
        @value={{selectedValue}}
        as |group|
      >
        <group.RadioField @label="option-1" @value="option-1" data-radio-1 />
        <group.RadioField @label="option-2" @value="option-2" data-radio-2 />
      </RadioGroupField>
    </template>);

    assert.verifySteps([]);

    assert.dom('[data-radio-1]').isNotChecked();

    await click('[data-radio-1]');

    assert.verifySteps(['handleChange']);

    assert.dom('[data-radio-1]').isChecked();
  });
});
