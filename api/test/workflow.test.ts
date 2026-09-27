import {test} from 'node:test';
import {strict as assert} from 'node:assert';
import {canTransition,estimateTotal} from '../src/workflow.js';
test('repair cannot start before approval',()=>{assert.equal(canTransition('ESTIMATE_PENDING','REPAIRING'),false);assert.equal(canTransition('ESTIMATE_APPROVED','REPAIRING'),true);});
test('terminal rescues cannot reopen',()=>{assert.equal(canTransition('COMPLETED','SEARCHING'),false);});
test('estimate uses integer paise',()=>{assert.equal(estimateTotal([{quantity:2,unitPaise:14900},{quantity:1,unitPaise:30000}]),59800);assert.throws(()=>estimateTotal([{quantity:1,unitPaise:-1}]));});
