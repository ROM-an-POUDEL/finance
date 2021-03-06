﻿-->-->-- src/Frapid.Web/Areas/MixERP.Finance/db/SQL Server/2.x/2.0/src/99.sample-data/00.default-values.sample.sql --<--<--
SET NOCOUNT ON;

/*
IMPORTANT:
The table account_masters must only be translated, but not changed.        
*/
UPDATE core.offices
SET allow_transaction_posting = 1;

INSERT INTO finance.frequencies(frequency_id, frequency_code, frequency_name)
SELECT 2, 'EOM', 'End of Month'                 UNION ALL
SELECT 3, 'EOQ', 'End of Quarter'               UNION ALL
SELECT 4, 'EOH', 'End of Half'                  UNION ALL
SELECT 5, 'EOY', 'End of Year';



INSERT INTO finance.account_masters(account_master_id, account_master_code, account_master_name)
SELECT 1, 'BSA', 'Balance Sheet A/C' UNION ALL
SELECT 2, 'PLA', 'Profit & Loss A/C' UNION ALL
SELECT 3, 'OBS', 'Off Balance Sheet A/C';

INSERT INTO finance.account_masters(account_master_id, account_master_code, account_master_name, parent_account_master_id, normally_debit)
SELECT 10100, 'CRA', 'Current Assets',                      1,      1    UNION ALL
SELECT 10101, 'CAS', 'Cash A/C',                            10100,  1    UNION ALL
SELECT 10102, 'CAB', 'Bank A/C',                            10100,  1    UNION ALL
SELECT 10110, 'ACR', 'Accounts Receivable',                 10100,  1    UNION ALL
SELECT 10200, 'FIA', 'Fixed Assets',                        1,      1    UNION ALL
SELECT 10201, 'PPE', 'Property, Plants, and Equipments',    1,      1    UNION ALL
SELECT 10300, 'OTA', 'Other Assets',                        1,      1    UNION ALL
SELECT 15000, 'CRL', 'Current Liabilities',                 1,      0	UNION ALL
SELECT 15001, 'CAP', 'Capital',                    			15000,  0   UNION ALL
SELECT 15010, 'ACP', 'Accounts Payable',                    15000,  0   UNION ALL
SELECT 15011, 'SAP', 'Salary Payable',                      15000,  0   UNION ALL
SELECT 15100, 'LTL', 'Long-Term Liabilities',               1,      0   UNION ALL
SELECT 15200, 'SHE', 'Shareholders'' Equity',               1,      0   UNION ALL
SELECT 15300, 'RET', 'Retained Earnings',                   15200,  0   UNION ALL
SELECT 15400, 'DIP', 'Dividends Paid',                      15300,  0;


INSERT INTO finance.account_masters(account_master_id, account_master_code, account_master_name, parent_account_master_id, normally_debit)
SELECT 20100, 'REV', 'Revenue',                           2,        0   UNION ALL
SELECT 20200, 'NOI', 'Non Operating Income',              2,        0   UNION ALL
SELECT 20300, 'FII', 'Financial Incomes',                 2,        0   UNION ALL
SELECT 20301, 'DIR', 'Dividends Received',                20300,    0   UNION ALL
SELECT 20400, 'COS', 'Cost of Sales',                     2,        1    UNION ALL
SELECT 20500, 'DRC', 'Direct Costs',                      2,        1    UNION ALL
SELECT 20600, 'ORX', 'Operating Expenses',                2,        1    UNION ALL
SELECT 20700, 'FIX', 'Financial Expenses',                2,        1    UNION ALL
SELECT 20701, 'INT', 'Interest Expenses',                 20700,    1    UNION ALL
SELECT 20800, 'ITX', 'Income Tax Expenses',               2,        1;

/*
IMPORTANT:
The table cash_flow_headings must only be translated, but not changed.        
*/
INSERT INTO finance.cash_flow_headings(cash_flow_heading_id, cash_flow_heading_code, cash_flow_heading_name, cash_flow_heading_type, is_debit)
SELECT 20001, 'CRC',    'Cash Receipts from Customers',                 'O',   1    UNION ALL
SELECT 20002, 'CPS',    'Cash Paid to Suppliers',                       'O',   0   UNION ALL
SELECT 20003, 'CPE',    'Cash Paid to Employees',                       'O',   0   UNION ALL
SELECT 20004, 'IP',     'Interest Paid',                                'O',   0   UNION ALL
SELECT 20005, 'ITP',    'Income Taxes Paid',                            'O',   0   UNION ALL
SELECT 20006, 'SUS',    'Against Suspense Accounts',                    'O',   1   UNION ALL
SELECT 30001, 'PSE',    'Proceeds from the Sale of Equipment',          'I',   1    UNION ALL
SELECT 30002, 'DR',     'Dividends Received',                           'I',   1    UNION ALL
SELECT 40001, 'DP',     'Dividends Paid',                               'F',   0;

UPDATE finance.cash_flow_headings SET is_sales= 1 WHERE cash_flow_heading_code='CRC';
UPDATE finance.cash_flow_headings SET is_purchase= 1 WHERE cash_flow_heading_code='CPS';

/*
IMPORTANT:
The table cash_flow_setup must only be translated, but not changed.
*/
INSERT INTO finance.cash_flow_setup(cash_flow_heading_id, account_master_id)
SELECT finance.get_cash_flow_heading_id_by_cash_flow_heading_code('CRC'), finance.get_account_master_id_by_account_master_code('ACR') UNION ALL --Cash Receipts from Customers/Accounts Receivable
SELECT finance.get_cash_flow_heading_id_by_cash_flow_heading_code('CPS'), finance.get_account_master_id_by_account_master_code('ACP') UNION ALL --Cash Paid to Suppliers/Accounts Payable
SELECT finance.get_cash_flow_heading_id_by_cash_flow_heading_code('CPE'), finance.get_account_master_id_by_account_master_code('SAP') UNION ALL --Cash Paid to Employees/Salary Payable
SELECT finance.get_cash_flow_heading_id_by_cash_flow_heading_code('IP'),  finance.get_account_master_id_by_account_master_code('INT') UNION ALL --Interest Paid/Interest Expenses
SELECT finance.get_cash_flow_heading_id_by_cash_flow_heading_code('ITP'), finance.get_account_master_id_by_account_master_code('ITX') UNION ALL --Income Taxes Paid/Income Tax Expenses
SELECT finance.get_cash_flow_heading_id_by_cash_flow_heading_code('PSE'), finance.get_account_master_id_by_account_master_code('PPE') UNION ALL --Proceeds from the Sale of Equipment/Property, Plants, and Equipments
SELECT finance.get_cash_flow_heading_id_by_cash_flow_heading_code('DR'),  finance.get_account_master_id_by_account_master_code('DIR') UNION ALL --Dividends Received/Dividends Received
SELECT finance.get_cash_flow_heading_id_by_cash_flow_heading_code('DP'),  finance.get_account_master_id_by_account_master_code('DIP') UNION ALL --Dividends Paid/Dividends Paid

--We cannot guarantee that every transactions posted is 100% correct and falls under the above-mentioned categories.
--The following is the list of suspense accounts, cash entries posted directly against all other account masters.
SELECT finance.get_cash_flow_heading_id_by_cash_flow_heading_code('SUS'), finance.get_account_master_id_by_account_master_code('BSA') UNION ALL --Against Suspense Accounts/Balance Sheet A/C
SELECT finance.get_cash_flow_heading_id_by_cash_flow_heading_code('SUS'), finance.get_account_master_id_by_account_master_code('PLA') UNION ALL --Against Suspense Accounts/Profit & Loss A/C
SELECT finance.get_cash_flow_heading_id_by_cash_flow_heading_code('SUS'), finance.get_account_master_id_by_account_master_code('CRA') UNION ALL --Against Suspense Accounts/Current Assets
SELECT finance.get_cash_flow_heading_id_by_cash_flow_heading_code('SUS'), finance.get_account_master_id_by_account_master_code('FIA') UNION ALL --Against Suspense Accounts/Fixed Assets
SELECT finance.get_cash_flow_heading_id_by_cash_flow_heading_code('SUS'), finance.get_account_master_id_by_account_master_code('OTA') UNION ALL --Against Suspense Accounts/Other Assets
SELECT finance.get_cash_flow_heading_id_by_cash_flow_heading_code('SUS'), finance.get_account_master_id_by_account_master_code('CRL') UNION ALL --Against Suspense Accounts/Current Liabilities
SELECT finance.get_cash_flow_heading_id_by_cash_flow_heading_code('SUS'), finance.get_account_master_id_by_account_master_code('LTL') UNION ALL --Against Suspense Accounts/Long-Term Liabilities
SELECT finance.get_cash_flow_heading_id_by_cash_flow_heading_code('SUS'), finance.get_account_master_id_by_account_master_code('SHE') UNION ALL --Against Suspense Accounts/Shareholders' Equity
SELECT finance.get_cash_flow_heading_id_by_cash_flow_heading_code('SUS'), finance.get_account_master_id_by_account_master_code('RET') UNION ALL --Against Suspense Accounts/Retained Earning
SELECT finance.get_cash_flow_heading_id_by_cash_flow_heading_code('SUS'), finance.get_account_master_id_by_account_master_code('REV') UNION ALL --Against Suspense Accounts/Revenue
SELECT finance.get_cash_flow_heading_id_by_cash_flow_heading_code('SUS'), finance.get_account_master_id_by_account_master_code('NOI') UNION ALL --Against Suspense Accounts/Non Operating Income
SELECT finance.get_cash_flow_heading_id_by_cash_flow_heading_code('SUS'), finance.get_account_master_id_by_account_master_code('FII') UNION ALL --Against Suspense Accounts/Financial Incomes
SELECT finance.get_cash_flow_heading_id_by_cash_flow_heading_code('SUS'), finance.get_account_master_id_by_account_master_code('COS') UNION ALL --Against Suspense Accounts/Cost of Sales
SELECT finance.get_cash_flow_heading_id_by_cash_flow_heading_code('SUS'), finance.get_account_master_id_by_account_master_code('DRC') UNION ALL --Against Suspense Accounts/Direct Costs
SELECT finance.get_cash_flow_heading_id_by_cash_flow_heading_code('SUS'), finance.get_account_master_id_by_account_master_code('ORX') UNION ALL --Against Suspense Accounts/Operating Expenses
SELECT finance.get_cash_flow_heading_id_by_cash_flow_heading_code('SUS'), finance.get_account_master_id_by_account_master_code('FIX');          --Against Suspense Accounts/Financial Expenses

GO

ALTER TABLE finance.accounts
ALTER column currency_code national character varying(12) NULL;

GO

INSERT INTO finance.accounts(account_master_id,account_number,account_name, sys_type, parent_account_id) 
SELECT 1,     '10000', 'Assets',                                                      1,  finance.get_account_id_by_account_name('Balance Sheet A/C');
INSERT INTO finance.accounts(account_master_id,account_number,account_name, sys_type, parent_account_id) 
SELECT 10100, '10001', 'Current Assets',                                              1,  finance.get_account_id_by_account_name('Assets');
INSERT INTO finance.accounts(account_master_id,account_number,account_name, sys_type, parent_account_id) 
SELECT 10102, '10100', 'Cash at Bank A/C',                                            1,  finance.get_account_id_by_account_name('Current Assets');
INSERT INTO finance.accounts(account_master_id,account_number,account_name, sys_type, parent_account_id) 
SELECT 10102, '10110', 'Regular Checking Account',                                    0, finance.get_account_id_by_account_name('Cash at Bank A/C');
INSERT INTO finance.accounts(account_master_id,account_number,account_name, sys_type, parent_account_id) 
SELECT 10102, '10120', 'Payroll Checking Account',                                    0, finance.get_account_id_by_account_name('Cash at Bank A/C');
INSERT INTO finance.accounts(account_master_id,account_number,account_name, sys_type, parent_account_id) 
SELECT 10102, '10130', 'Savings Account',                                             0, finance.get_account_id_by_account_name('Cash at Bank A/C');
INSERT INTO finance.accounts(account_master_id,account_number,account_name, sys_type, parent_account_id) 
SELECT 10102, '10140', 'Special Account',                                             0, finance.get_account_id_by_account_name('Cash at Bank A/C');
INSERT INTO finance.accounts(account_master_id,account_number,account_name, sys_type, parent_account_id) 
SELECT 10101, '10200', 'Cash in Hand A/C',                                            1,  finance.get_account_id_by_account_name('Current Assets');
INSERT INTO finance.accounts(account_master_id,account_number,account_name, sys_type, parent_account_id) 
SELECT 10100, '10300', 'Investments',                                                 0, finance.get_account_id_by_account_name('Current Assets');
INSERT INTO finance.accounts(account_master_id,account_number,account_name, sys_type, parent_account_id) 
SELECT 10100, '10310', 'Short Term Investment',                                       0, finance.get_account_id_by_account_name('Investments');
INSERT INTO finance.accounts(account_master_id,account_number,account_name, sys_type, parent_account_id) 
SELECT 10100, '10320', 'Other Investments',                                           0, finance.get_account_id_by_account_name('Investments');
INSERT INTO finance.accounts(account_master_id,account_number,account_name, sys_type, parent_account_id) 
SELECT 10100, '10321', 'Investments-Money Market',                                    0, finance.get_account_id_by_account_name('Other Investments');
INSERT INTO finance.accounts(account_master_id,account_number,account_name, sys_type, parent_account_id) 
SELECT 10100, '10322', 'Bank Deposit Contract (Fixed Deposit)',                       0, finance.get_account_id_by_account_name('Other Investments');
INSERT INTO finance.accounts(account_master_id,account_number,account_name, sys_type, parent_account_id) 
SELECT 10100, '10323', 'Investments-Certificates of Deposit',                         0, finance.get_account_id_by_account_name('Other Investments');
INSERT INTO finance.accounts(account_master_id,account_number,account_name, sys_type, parent_account_id) 
SELECT 10110, '10400', 'Accounts Receivable',                                         0, finance.get_account_id_by_account_name('Current Assets');
INSERT INTO finance.accounts(account_master_id,account_number,account_name, sys_type, parent_account_id) 
SELECT 10100, '10500', 'Other Receivables',                                           0, finance.get_account_id_by_account_name('Current Assets');
INSERT INTO finance.accounts(account_master_id,account_number,account_name, sys_type, parent_account_id) 
SELECT 10100, '10501', 'Purchase Return (Receivables)',                               0, finance.get_account_id_by_account_name('Other Receivables');
INSERT INTO finance.accounts(account_master_id,account_number,account_name, sys_type, parent_account_id) 
SELECT 10100, '10600', 'Allowance for Doubtful Accounts',                             0, finance.get_account_id_by_account_name('Current Assets');
INSERT INTO finance.accounts(account_master_id,account_number,account_name, sys_type, parent_account_id) 
SELECT 10100, '10700', 'Inventory',                                                   1,  finance.get_account_id_by_account_name('Current Assets');
INSERT INTO finance.accounts(account_master_id,account_number,account_name, sys_type, parent_account_id) 
SELECT 10100, '10720', 'Raw Materials Inventory',                                     1,  finance.get_account_id_by_account_name('Inventory');
INSERT INTO finance.accounts(account_master_id,account_number,account_name, sys_type, parent_account_id) 
SELECT 10100, '10730', 'Supplies Inventory',                                          1,  finance.get_account_id_by_account_name('Inventory');
INSERT INTO finance.accounts(account_master_id,account_number,account_name, sys_type, parent_account_id) 
SELECT 10100, '10740', 'Work in Progress Inventory',                                  1,  finance.get_account_id_by_account_name('Inventory');
INSERT INTO finance.accounts(account_master_id,account_number,account_name, sys_type, parent_account_id) 
SELECT 10100, '10750', 'Finished ods Inventory',                                    1,  finance.get_account_id_by_account_name('Inventory');
INSERT INTO finance.accounts(account_master_id,account_number,account_name, sys_type, parent_account_id) 
SELECT 10100, '10800', 'Prepaid Expenses',                                            0, finance.get_account_id_by_account_name('Current Assets');
INSERT INTO finance.accounts(account_master_id,account_number,account_name, sys_type, parent_account_id) 
SELECT 10100, '10900', 'Employee Advances',                                           0, finance.get_account_id_by_account_name('Current Assets');
INSERT INTO finance.accounts(account_master_id,account_number,account_name, sys_type, parent_account_id) 
SELECT 10100, '11000', 'Notes Receivable-Current',                                    0, finance.get_account_id_by_account_name('Current Assets');
INSERT INTO finance.accounts(account_master_id,account_number,account_name, sys_type, parent_account_id) 
SELECT 10100, '11100', 'Prepaid Interest',                                            0, finance.get_account_id_by_account_name('Current Assets');
INSERT INTO finance.accounts(account_master_id,account_number,account_name, sys_type, parent_account_id) 
SELECT 10100, '11200', 'Accrued Incomes (Assets)',                                    0, finance.get_account_id_by_account_name('Current Assets');
INSERT INTO finance.accounts(account_master_id,account_number,account_name, sys_type, parent_account_id) 
SELECT 10100, '11300', 'Other Debtors',                                               0, finance.get_account_id_by_account_name('Current Assets');
INSERT INTO finance.accounts(account_master_id,account_number,account_name, sys_type, parent_account_id) 
SELECT 10100, '11400', 'Other Current Assets',                                        0, finance.get_account_id_by_account_name('Current Assets');
INSERT INTO finance.accounts(account_master_id,account_number,account_name, sys_type, parent_account_id) 
SELECT 10200, '12001', 'Noncurrent Assets',                                           1,  finance.get_account_id_by_account_name('Assets');
INSERT INTO finance.accounts(account_master_id,account_number,account_name, sys_type, parent_account_id) 
SELECT 10200, '12100', 'Furniture and Fixtures',                                      0, finance.get_account_id_by_account_name('Noncurrent Assets');
INSERT INTO finance.accounts(account_master_id,account_number,account_name, sys_type, parent_account_id) 
SELECT 10201, '12200', 'Plants & Equipments',                                         0, finance.get_account_id_by_account_name('Noncurrent Assets');
INSERT INTO finance.accounts(account_master_id,account_number,account_name, sys_type, parent_account_id) 
SELECT 10200, '12300', 'Rental Property',                                             0, finance.get_account_id_by_account_name('Noncurrent Assets');
INSERT INTO finance.accounts(account_master_id,account_number,account_name, sys_type, parent_account_id) 
SELECT 10200, '12400', 'Vehicles',                                                    0, finance.get_account_id_by_account_name('Noncurrent Assets');
INSERT INTO finance.accounts(account_master_id,account_number,account_name, sys_type, parent_account_id) 
SELECT 10200, '12500', 'Intangibles',                                                 0, finance.get_account_id_by_account_name('Noncurrent Assets');
INSERT INTO finance.accounts(account_master_id,account_number,account_name, sys_type, parent_account_id) 
SELECT 10200, '12600', 'Other Depreciable Properties',                                0, finance.get_account_id_by_account_name('Noncurrent Assets');
INSERT INTO finance.accounts(account_master_id,account_number,account_name, sys_type, parent_account_id) 
SELECT 10200, '12700', 'Leasehold Improvements',                                      0, finance.get_account_id_by_account_name('Noncurrent Assets');
INSERT INTO finance.accounts(account_master_id,account_number,account_name, sys_type, parent_account_id) 
SELECT 10200, '12800', 'Buildings',                                                   0, finance.get_account_id_by_account_name('Noncurrent Assets');
INSERT INTO finance.accounts(account_master_id,account_number,account_name, sys_type, parent_account_id) 
SELECT 10200, '12900', 'Building Improvements',                                       0, finance.get_account_id_by_account_name('Noncurrent Assets');
INSERT INTO finance.accounts(account_master_id,account_number,account_name, sys_type, parent_account_id) 
SELECT 10200, '13000', 'Interior Decorations',                                        0, finance.get_account_id_by_account_name('Noncurrent Assets');
INSERT INTO finance.accounts(account_master_id,account_number,account_name, sys_type, parent_account_id) 
SELECT 10200, '13100', 'Land',                                                        0, finance.get_account_id_by_account_name('Noncurrent Assets');
INSERT INTO finance.accounts(account_master_id,account_number,account_name, sys_type, parent_account_id) 
SELECT 10200, '13200', 'Long Term Investments',                                       0, finance.get_account_id_by_account_name('Noncurrent Assets');
INSERT INTO finance.accounts(account_master_id,account_number,account_name, sys_type, parent_account_id) 
SELECT 10200, '13300', 'Trade Debtors',                                               0, finance.get_account_id_by_account_name('Noncurrent Assets');
INSERT INTO finance.accounts(account_master_id,account_number,account_name, sys_type, parent_account_id) 
SELECT 10200, '13400', 'Rental Debtors',                                              0, finance.get_account_id_by_account_name('Noncurrent Assets');
INSERT INTO finance.accounts(account_master_id,account_number,account_name, sys_type, parent_account_id) 
SELECT 10200, '13500', 'Staff Debtors',                                               0, finance.get_account_id_by_account_name('Noncurrent Assets');
INSERT INTO finance.accounts(account_master_id,account_number,account_name, sys_type, parent_account_id) 
SELECT 10200, '13600', 'Other Noncurrent Debtors',                                    0, finance.get_account_id_by_account_name('Noncurrent Assets');
INSERT INTO finance.accounts(account_master_id,account_number,account_name, sys_type, parent_account_id) 
SELECT 10200, '13700', 'Other Financial Assets',                                      0, finance.get_account_id_by_account_name('Noncurrent Assets');
INSERT INTO finance.accounts(account_master_id,account_number,account_name, sys_type, parent_account_id) 
SELECT 10200, '13710', 'Deposits Held',                                               0, finance.get_account_id_by_account_name('Other Financial Assets');
INSERT INTO finance.accounts(account_master_id,account_number,account_name, sys_type, parent_account_id) 
SELECT 10200, '13800', 'Accumulated Depreciations',                                   0, finance.get_account_id_by_account_name('Noncurrent Assets');
INSERT INTO finance.accounts(account_master_id,account_number,account_name, sys_type, parent_account_id) 
SELECT 10200, '13810', 'Accumulated Depreciation-Furniture and Fixtures',             0, finance.get_account_id_by_account_name('Accumulated Depreciations');
INSERT INTO finance.accounts(account_master_id,account_number,account_name, sys_type, parent_account_id) 
SELECT 10200, '13820', 'Accumulated Depreciation-Equipment',                          0, finance.get_account_id_by_account_name('Accumulated Depreciations');
INSERT INTO finance.accounts(account_master_id,account_number,account_name, sys_type, parent_account_id) 
SELECT 10200, '13830', 'Accumulated Depreciation-Vehicles',                           0, finance.get_account_id_by_account_name('Accumulated Depreciations');
INSERT INTO finance.accounts(account_master_id,account_number,account_name, sys_type, parent_account_id) 
SELECT 10200, '13840', 'Accumulated Depreciation-Other Depreciable Properties',       0, finance.get_account_id_by_account_name('Accumulated Depreciations');
INSERT INTO finance.accounts(account_master_id,account_number,account_name, sys_type, parent_account_id) 
SELECT 10200, '13850', 'Accumulated Depreciation-Leasehold',                          0, finance.get_account_id_by_account_name('Accumulated Depreciations');
INSERT INTO finance.accounts(account_master_id,account_number,account_name, sys_type, parent_account_id) 
SELECT 10200, '13860', 'Accumulated Depreciation-Buildings',                          0, finance.get_account_id_by_account_name('Accumulated Depreciations');
INSERT INTO finance.accounts(account_master_id,account_number,account_name, sys_type, parent_account_id) 
SELECT 10200, '13870', 'Accumulated Depreciation-Building Improvements',              0, finance.get_account_id_by_account_name('Accumulated Depreciations');
INSERT INTO finance.accounts(account_master_id,account_number,account_name, sys_type, parent_account_id) 
SELECT 10200, '13880', 'Accumulated Depreciation-Interior Decorations',               0, finance.get_account_id_by_account_name('Accumulated Depreciations');
INSERT INTO finance.accounts(account_master_id,account_number,account_name, sys_type, parent_account_id) 
SELECT 10300, '14001', 'Other Assets',                                                1,  finance.get_account_id_by_account_name('Assets');
INSERT INTO finance.accounts(account_master_id,account_number,account_name, sys_type, parent_account_id) 
SELECT 10300, '14100', 'Other Assets-Deposits',                                       0, finance.get_account_id_by_account_name('Other Assets');
INSERT INTO finance.accounts(account_master_id,account_number,account_name, sys_type, parent_account_id) 
SELECT 10300, '14200', 'Other Assets-Organization Costs',                             0, finance.get_account_id_by_account_name('Other Assets');
INSERT INTO finance.accounts(account_master_id,account_number,account_name, sys_type, parent_account_id) 
SELECT 10300, '14300', 'Other Assets-Accumulated Amortization-Organization Costs',    0, finance.get_account_id_by_account_name('Other Assets');
INSERT INTO finance.accounts(account_master_id,account_number,account_name, sys_type, parent_account_id) 
SELECT 10300, '14400', 'Notes Receivable-Non-current',                                0, finance.get_account_id_by_account_name('Other Assets');
INSERT INTO finance.accounts(account_master_id,account_number,account_name, sys_type, parent_account_id) 
SELECT 10300, '14500', 'Other Non-current Assets',                                    0, finance.get_account_id_by_account_name('Other Assets');
INSERT INTO finance.accounts(account_master_id,account_number,account_name, sys_type, parent_account_id) 
SELECT 10300, '14600', 'Non-financial Assets',                                        0, finance.get_account_id_by_account_name('Other Assets');
INSERT INTO finance.accounts(account_master_id,account_number,account_name, sys_type, parent_account_id) 
SELECT 1,     '20000', 'Liabilities',                                                 1,  finance.get_account_id_by_account_name('Balance Sheet A/C');
INSERT INTO finance.accounts(account_master_id,account_number,account_name, sys_type, parent_account_id) 
SELECT 15000, '20001', 'Current Liabilities',                                         1,  finance.get_account_id_by_account_name('Liabilities');
INSERT INTO finance.accounts(account_master_id,account_number,account_name, sys_type, parent_account_id) 
SELECT 15001, '20010', 'Shareholders',                                            0, finance.get_account_id_by_account_name('Liabilities');
INSERT INTO finance.accounts(account_master_id,account_number,account_name, sys_type, parent_account_id) 
SELECT 15010, '20100', 'Accounts Payable',                                            0, finance.get_account_id_by_account_name('Current Liabilities');
INSERT INTO finance.accounts(account_master_id,account_number,account_name, sys_type, parent_account_id) 
SELECT 15000, '20110', 'Shipping Charge Payable',                                     0, finance.get_account_id_by_account_name('Current Liabilities');
INSERT INTO finance.accounts(account_master_id,account_number,account_name, sys_type, parent_account_id) 
SELECT 15000, '20200', 'Accrued Expenses',                                            0, finance.get_account_id_by_account_name('Current Liabilities');
INSERT INTO finance.accounts(account_master_id,account_number,account_name, sys_type, parent_account_id) 
SELECT 15000, '20300', 'Wages Payable',                                               0, finance.get_account_id_by_account_name('Current Liabilities');
INSERT INTO finance.accounts(account_master_id,account_number,account_name, sys_type, parent_account_id) 
SELECT 15000, '20400', 'Deductions Payable',                                          0, finance.get_account_id_by_account_name('Current Liabilities');
INSERT INTO finance.accounts(account_master_id,account_number,account_name, sys_type, parent_account_id) 
SELECT 15000, '20500', 'Health Insurance Payable',                                    0, finance.get_account_id_by_account_name('Current Liabilities');
INSERT INTO finance.accounts(account_master_id,account_number,account_name, sys_type, parent_account_id) 
SELECT 15000, '20600', 'Superannuation Payable',                                      0, finance.get_account_id_by_account_name('Current Liabilities');
INSERT INTO finance.accounts(account_master_id,account_number,account_name, sys_type, parent_account_id) 
SELECT 15000, '20700', 'Tax Payables',                                                0, finance.get_account_id_by_account_name('Current Liabilities');
INSERT INTO finance.accounts(account_master_id,account_number,account_name, sys_type, parent_account_id) 
SELECT 15000, '20701', 'Sales Return (Payables)',                                     0, finance.get_account_id_by_account_name('Current Liabilities');
INSERT INTO finance.accounts(account_master_id,account_number,account_name, sys_type, parent_account_id) 
SELECT 15000, '20710', 'Sales Tax Payable',                                           0, finance.get_account_id_by_account_name('Tax Payables');
INSERT INTO finance.accounts(account_master_id,account_number,account_name, sys_type, parent_account_id) 
SELECT 15000, '20720', 'Federal Payroll Taxes Payable',                               0, finance.get_account_id_by_account_name('Tax Payables');
INSERT INTO finance.accounts(account_master_id,account_number,account_name, sys_type, parent_account_id) 
SELECT 15000, '20730', 'FUTA Tax Payable',                                            0, finance.get_account_id_by_account_name('Tax Payables');
INSERT INTO finance.accounts(account_master_id,account_number,account_name, sys_type, parent_account_id) 
SELECT 15000, '20740', 'State Payroll Taxes Payable',                                 0, finance.get_account_id_by_account_name('Tax Payables');
INSERT INTO finance.accounts(account_master_id,account_number,account_name, sys_type, parent_account_id) 
SELECT 15000, '20750', 'SUTA Payable',                                                0, finance.get_account_id_by_account_name('Tax Payables');
INSERT INTO finance.accounts(account_master_id,account_number,account_name, sys_type, parent_account_id) 
SELECT 15000, '20760', 'Local Payroll Taxes Payable',                                 0, finance.get_account_id_by_account_name('Tax Payables');
INSERT INTO finance.accounts(account_master_id,account_number,account_name, sys_type, parent_account_id) 
SELECT 15000, '20770', 'Income Taxes Payable',                                        0, finance.get_account_id_by_account_name('Tax Payables');
INSERT INTO finance.accounts(account_master_id,account_number,account_name, sys_type, parent_account_id) 
SELECT 15000, '20780', 'Other Taxes Payable',                                         0, finance.get_account_id_by_account_name('Tax Payables');
INSERT INTO finance.accounts(account_master_id,account_number,account_name, sys_type, parent_account_id) 
SELECT 15000, '20800', 'Employee Benefits Payable',                                   0, finance.get_account_id_by_account_name('Current Liabilities');
INSERT INTO finance.accounts(account_master_id,account_number,account_name, sys_type, parent_account_id) 
SELECT 15000, '20810', 'Provision for Annual Leave',                                  0, finance.get_account_id_by_account_name('Employee Benefits Payable');
INSERT INTO finance.accounts(account_master_id,account_number,account_name, sys_type, parent_account_id) 
SELECT 15000, '20820', 'Provision for Long Service Leave',                            0, finance.get_account_id_by_account_name('Employee Benefits Payable');
INSERT INTO finance.accounts(account_master_id,account_number,account_name, sys_type, parent_account_id) 
SELECT 15000, '20830', 'Provision for Personal Leave',                                0, finance.get_account_id_by_account_name('Employee Benefits Payable');
INSERT INTO finance.accounts(account_master_id,account_number,account_name, sys_type, parent_account_id) 
SELECT 15000, '20840', 'Provision for Health Leave',                                  0, finance.get_account_id_by_account_name('Employee Benefits Payable');
INSERT INTO finance.accounts(account_master_id,account_number,account_name, sys_type, parent_account_id) 
SELECT 15000, '20900', 'Current Portion of Long-term Debt',                           0, finance.get_account_id_by_account_name('Current Liabilities');
INSERT INTO finance.accounts(account_master_id,account_number,account_name, sys_type, parent_account_id) 
SELECT 15000, '21000', 'Advance Incomes',                                             0, finance.get_account_id_by_account_name('Current Liabilities');
INSERT INTO finance.accounts(account_master_id,account_number,account_name, sys_type, parent_account_id) 
SELECT 15000, '21010', 'Advance Sales Income',                                        0, finance.get_account_id_by_account_name('Advance Incomes');
INSERT INTO finance.accounts(account_master_id,account_number,account_name, sys_type, parent_account_id) 
SELECT 15000, '21020', 'Grant Received in Advance',                                   0, finance.get_account_id_by_account_name('Advance Incomes');
INSERT INTO finance.accounts(account_master_id,account_number,account_name, sys_type, parent_account_id) 
SELECT 15000, '21100', 'Deposits from Customers',                                     0, finance.get_account_id_by_account_name('Current Liabilities');
INSERT INTO finance.accounts(account_master_id,account_number,account_name, sys_type, parent_account_id) 
SELECT 15000, '21200', 'Other Current Liabilities',                                   0, finance.get_account_id_by_account_name('Current Liabilities');
INSERT INTO finance.accounts(account_master_id,account_number,account_name, sys_type, parent_account_id) 
SELECT 15000, '21210', 'Short Term Loan Payables',                                    0, finance.get_account_id_by_account_name('Other Current Liabilities');
INSERT INTO finance.accounts(account_master_id,account_number,account_name, sys_type, parent_account_id) 
SELECT 15000, '21220', 'Short Term Hire-purchase Payables',                           0, finance.get_account_id_by_account_name('Other Current Liabilities');
INSERT INTO finance.accounts(account_master_id,account_number,account_name, sys_type, parent_account_id) 
SELECT 15000, '21230', 'Short Term Lease Liability',                                  0, finance.get_account_id_by_account_name('Other Current Liabilities');
INSERT INTO finance.accounts(account_master_id,account_number,account_name, sys_type, parent_account_id) 
SELECT 15000, '21240', 'Grants Repayable',                                            0, finance.get_account_id_by_account_name('Other Current Liabilities');
INSERT INTO finance.accounts(account_master_id,account_number,account_name, sys_type, parent_account_id) 
SELECT 15100, '24001', 'Noncurrent Liabilities',                                      1,  finance.get_account_id_by_account_name('Liabilities');
INSERT INTO finance.accounts(account_master_id,account_number,account_name, sys_type, parent_account_id) 
SELECT 15100, '24100', 'Notes Payable',                                               0, finance.get_account_id_by_account_name('Noncurrent Liabilities');
INSERT INTO finance.accounts(account_master_id,account_number,account_name, sys_type, parent_account_id) 
SELECT 15100, '24200', 'Land Payable',                                                0, finance.get_account_id_by_account_name('Noncurrent Liabilities');
INSERT INTO finance.accounts(account_master_id,account_number,account_name, sys_type, parent_account_id) 
SELECT 15100, '24300', 'Equipment Payable',                                           0, finance.get_account_id_by_account_name('Noncurrent Liabilities');
INSERT INTO finance.accounts(account_master_id,account_number,account_name, sys_type, parent_account_id) 
SELECT 15100, '24400', 'Vehicles Payable',                                            0, finance.get_account_id_by_account_name('Noncurrent Liabilities');
INSERT INTO finance.accounts(account_master_id,account_number,account_name, sys_type, parent_account_id) 
SELECT 15100, '24500', 'Lease Liability',                                             0, finance.get_account_id_by_account_name('Noncurrent Liabilities');
INSERT INTO finance.accounts(account_master_id,account_number,account_name, sys_type, parent_account_id) 
SELECT 15100, '24600', 'Loan Payable',                                                0, finance.get_account_id_by_account_name('Noncurrent Liabilities');
INSERT INTO finance.accounts(account_master_id,account_number,account_name, sys_type, parent_account_id) 
SELECT 15100, '24700', 'Hire-purchase Payable',                                       0, finance.get_account_id_by_account_name('Noncurrent Liabilities');
INSERT INTO finance.accounts(account_master_id,account_number,account_name, sys_type, parent_account_id) 
SELECT 15100, '24800', 'Bank Loans Payable',                                          0, finance.get_account_id_by_account_name('Noncurrent Liabilities');
INSERT INTO finance.accounts(account_master_id,account_number,account_name, sys_type, parent_account_id) 
SELECT 15100, '24900', 'Deferred Revenue',                                            0, finance.get_account_id_by_account_name('Noncurrent Liabilities');
INSERT INTO finance.accounts(account_master_id,account_number,account_name, sys_type, parent_account_id) 
SELECT 15100, '25000', 'Other Long-term Liabilities',                                 0, finance.get_account_id_by_account_name('Noncurrent Liabilities');
INSERT INTO finance.accounts(account_master_id,account_number,account_name, sys_type, parent_account_id) 
SELECT 15100, '25010', 'Long Term Employee Benefit Provision',                        0, finance.get_account_id_by_account_name('Other Long-term Liabilities');
INSERT INTO finance.accounts(account_master_id,account_number,account_name, sys_type, parent_account_id) 
SELECT 15200, '28001', 'Equity',                                                      1,  finance.get_account_id_by_account_name('Liabilities');
INSERT INTO finance.accounts(account_master_id,account_number,account_name, sys_type, parent_account_id) 
SELECT 15200, '28100', 'Stated Capital',                                              0, finance.get_account_id_by_account_name('Equity');
INSERT INTO finance.accounts(account_master_id,account_number,account_name, sys_type, parent_account_id) 
SELECT 15200, '28110', 'Founder Capital',                                             0, finance.get_account_id_by_account_name('Stated Capital');
INSERT INTO finance.accounts(account_master_id,account_number,account_name, sys_type, parent_account_id) 
SELECT 15200, '28120', 'Promoter Capital',                                            0, finance.get_account_id_by_account_name('Stated Capital');
INSERT INTO finance.accounts(account_master_id,account_number,account_name, sys_type, parent_account_id) 
SELECT 15200, '28130', 'Member Capital',                                              0, finance.get_account_id_by_account_name('Stated Capital');
INSERT INTO finance.accounts(account_master_id,account_number,account_name, sys_type, parent_account_id) 
SELECT 15200, '28200', 'Capital Surplus',                                             0, finance.get_account_id_by_account_name('Equity');
INSERT INTO finance.accounts(account_master_id,account_number,account_name, sys_type, parent_account_id) 
SELECT 15200, '28210', 'Share Premium',                                               0, finance.get_account_id_by_account_name('Capital Surplus');
INSERT INTO finance.accounts(account_master_id,account_number,account_name, sys_type, parent_account_id) 
SELECT 15200, '28220', 'Capital Redemption Reserves',                                 0, finance.get_account_id_by_account_name('Capital Surplus');
INSERT INTO finance.accounts(account_master_id,account_number,account_name, sys_type, parent_account_id) 
SELECT 15200, '28230', 'Statutory Reserves',                                          0, finance.get_account_id_by_account_name('Capital Surplus');
INSERT INTO finance.accounts(account_master_id,account_number,account_name, sys_type, parent_account_id) 
SELECT 15200, '28240', 'Asset Revaluation Reserves',                                  0, finance.get_account_id_by_account_name('Capital Surplus');
INSERT INTO finance.accounts(account_master_id,account_number,account_name, sys_type, parent_account_id) 
SELECT 15200, '28250', 'Exchange Rate Fluctuation Reserves',                          0, finance.get_account_id_by_account_name('Capital Surplus');
INSERT INTO finance.accounts(account_master_id,account_number,account_name, sys_type, parent_account_id) 
SELECT 15200, '28260', 'Capital Reserves Arising From Merger',                        0, finance.get_account_id_by_account_name('Capital Surplus');
INSERT INTO finance.accounts(account_master_id,account_number,account_name, sys_type, parent_account_id) 
SELECT 15200, '28270', 'Capital Reserves Arising From Acuisition',                    0, finance.get_account_id_by_account_name('Capital Surplus');
INSERT INTO finance.accounts(account_master_id,account_number,account_name, sys_type, parent_account_id) 
SELECT 15300, '28300', 'Retained Surplus',                                            1,  finance.get_account_id_by_account_name('Equity');
INSERT INTO finance.accounts(account_master_id,account_number,account_name, sys_type, parent_account_id) 
SELECT 15300, '28310', 'Accumulated Profits',                                         0, finance.get_account_id_by_account_name('Retained Surplus');
INSERT INTO finance.accounts(account_master_id,account_number,account_name, sys_type, parent_account_id) 
SELECT 15300, '28320', 'Accumulated Losses',                                          0, finance.get_account_id_by_account_name('Retained Surplus');
INSERT INTO finance.accounts(account_master_id,account_number,account_name, sys_type, parent_account_id) 
SELECT 15400, '28330', 'Dividends Declared (Common Stock)',                           0, finance.get_account_id_by_account_name('Retained Surplus');
INSERT INTO finance.accounts(account_master_id,account_number,account_name, sys_type, parent_account_id) 
SELECT 15400, '28340', 'Dividends Declared (Preferred Stock)',                        0, finance.get_account_id_by_account_name('Retained Surplus');
INSERT INTO finance.accounts(account_master_id,account_number,account_name, sys_type, parent_account_id) 
SELECT 15200, '28400', 'Treasury Stock',                                              0, finance.get_account_id_by_account_name('Equity');
INSERT INTO finance.accounts(account_master_id,account_number,account_name, sys_type, parent_account_id) 
SELECT 15200, '28500', 'Current Year Surplus',                                        0, finance.get_account_id_by_account_name('Equity');
INSERT INTO finance.accounts(account_master_id,account_number,account_name, sys_type, parent_account_id) 
SELECT 15200, '28600', 'General Reserves',                                            0, finance.get_account_id_by_account_name('Equity');
INSERT INTO finance.accounts(account_master_id,account_number,account_name, sys_type, parent_account_id) 
SELECT 15200, '28700', 'Other Reserves',                                              0, finance.get_account_id_by_account_name('Equity');
INSERT INTO finance.accounts(account_master_id,account_number,account_name, sys_type, parent_account_id) 
SELECT 15200, '28800', 'Dividends Payable (Common Stock)',                            0, finance.get_account_id_by_account_name('Equity');
INSERT INTO finance.accounts(account_master_id,account_number,account_name, sys_type, parent_account_id) 
SELECT 15200, '28900', 'Dividends Payable (Preferred Stock)',                         0, finance.get_account_id_by_account_name('Equity');
INSERT INTO finance.accounts(account_master_id,account_number,account_name, sys_type, parent_account_id) 
SELECT 2,     '30000', 'Revenues',                                                    1,  finance.get_account_id_by_account_name('Profit and Loss A/C');
INSERT INTO finance.accounts(account_master_id,account_number,account_name, sys_type, parent_account_id) 
SELECT 20100,  '30100', 'Sales A/C',                                                  0, finance.get_account_id_by_account_name('Revenues');
INSERT INTO finance.accounts(account_master_id,account_number,account_name, sys_type, parent_account_id) 
SELECT 20100,  '30200', 'Interest Income',                                            0, finance.get_account_id_by_account_name('Revenues');
INSERT INTO finance.accounts(account_master_id,account_number,account_name, sys_type, parent_account_id) 
SELECT 20100,  '30300', 'Other Income',                                               0, finance.get_account_id_by_account_name('Revenues');
INSERT INTO finance.accounts(account_master_id,account_number,account_name, sys_type, parent_account_id) 
SELECT 20100,  '30400', 'Finance Charge Income',                                      0, finance.get_account_id_by_account_name('Revenues');
INSERT INTO finance.accounts(account_master_id,account_number,account_name, sys_type, parent_account_id) 
SELECT 20100,  '30500', 'Shipping Charges Reimbursed',                                0, finance.get_account_id_by_account_name('Revenues');
INSERT INTO finance.accounts(account_master_id,account_number,account_name, sys_type, parent_account_id) 
SELECT 20100,  '30600', 'Sales Returns and Allowances',                               0, finance.get_account_id_by_account_name('Revenues');
INSERT INTO finance.accounts(account_master_id,account_number,account_name, sys_type, parent_account_id) 
SELECT 20100,  '30700', 'Purchase Discounts',                                         0, finance.get_account_id_by_account_name('Revenues');
INSERT INTO finance.accounts(account_master_id,account_number,account_name, sys_type, parent_account_id) 
SELECT 2,     '40000', 'Expenses',                                                    1,  finance.get_account_id_by_account_name('Profit and Loss A/C');
INSERT INTO finance.accounts(account_master_id,account_number,account_name, sys_type, parent_account_id) 
SELECT 2,     '40100', 'Purchase A/C',                                                0, finance.get_account_id_by_account_name('Expenses');
INSERT INTO finance.accounts(account_master_id,account_number,account_name, sys_type, parent_account_id) 
SELECT 20400,  '40200', 'Cost of Goods Sold',                                         0, finance.get_account_id_by_account_name('Expenses');
INSERT INTO finance.accounts(account_master_id,account_number,account_name, sys_type, parent_account_id) 
SELECT 20500,  '40205', 'Product Cost',                                               0, finance.get_account_id_by_account_name('Cost of Goods Sold');
INSERT INTO finance.accounts(account_master_id,account_number,account_name, sys_type, parent_account_id) 
SELECT 20500,  '40210', 'Raw Material Purchases',                                     0, finance.get_account_id_by_account_name('Cost of Goods Sold');
INSERT INTO finance.accounts(account_master_id,account_number,account_name, sys_type, parent_account_id) 
SELECT 20500,  '40215', 'Direct Labor Costs',                                         0, finance.get_account_id_by_account_name('Cost of Goods Sold');
INSERT INTO finance.accounts(account_master_id,account_number,account_name, sys_type, parent_account_id) 
SELECT 20500,  '40220', 'Indirect Labor Costs',                                       0, finance.get_account_id_by_account_name('Cost of Goods Sold');
INSERT INTO finance.accounts(account_master_id,account_number,account_name, sys_type, parent_account_id) 
SELECT 20500,  '40225', 'Heat and Power',                                             0, finance.get_account_id_by_account_name('Cost of Goods Sold');
INSERT INTO finance.accounts(account_master_id,account_number,account_name, sys_type, parent_account_id) 
SELECT 20500,  '40230', 'Commissions',                                                0, finance.get_account_id_by_account_name('Cost of Goods Sold');
INSERT INTO finance.accounts(account_master_id,account_number,account_name, sys_type, parent_account_id) 
SELECT 20500,  '40235', 'Miscellaneous Factory Costs',                                0, finance.get_account_id_by_account_name('Cost of Goods Sold');
INSERT INTO finance.accounts(account_master_id,account_number,account_name, sys_type, parent_account_id) 
SELECT 20500,  '40240', 'Cost of Goods Sold-Salaries and Wages',                      0, finance.get_account_id_by_account_name('Cost of Goods Sold');
INSERT INTO finance.accounts(account_master_id,account_number,account_name, sys_type, parent_account_id) 
SELECT 20500,  '40245', 'Cost of Goods Sold-Contract Labor',                          0, finance.get_account_id_by_account_name('Cost of Goods Sold');
INSERT INTO finance.accounts(account_master_id,account_number,account_name, sys_type, parent_account_id) 
SELECT 20500,  '40250', 'Cost of Goods Sold-Freight',                                 0, finance.get_account_id_by_account_name('Cost of Goods Sold');
INSERT INTO finance.accounts(account_master_id,account_number,account_name, sys_type, parent_account_id) 
SELECT 20500,  '40255', 'Cost of Goods Sold-Other',                                   0, finance.get_account_id_by_account_name('Cost of Goods Sold');
INSERT INTO finance.accounts(account_master_id,account_number,account_name, sys_type, parent_account_id) 
SELECT 20500,  '40260', 'Inventory Adjustments',                                      0, finance.get_account_id_by_account_name('Cost of Goods Sold');
INSERT INTO finance.accounts(account_master_id,account_number,account_name, sys_type, parent_account_id) 
SELECT 20500,  '40265', 'Purchase Returns and Allowances',                            0, finance.get_account_id_by_account_name('Cost of Goods Sold');
INSERT INTO finance.accounts(account_master_id,account_number,account_name, sys_type, parent_account_id) 
SELECT 20500,  '40270', 'Sales Discounts',                                            0, finance.get_account_id_by_account_name('Cost of Goods Sold');
INSERT INTO finance.accounts(account_master_id,account_number,account_name, sys_type, parent_account_id) 
SELECT 20600,  '40300', 'General Purchase Expenses',                                  0, finance.get_account_id_by_account_name('Expenses');
INSERT INTO finance.accounts(account_master_id,account_number,account_name, sys_type, parent_account_id) 
SELECT 20600,  '40400', 'Advertising Expenses',                                       0, finance.get_account_id_by_account_name('Expenses');
INSERT INTO finance.accounts(account_master_id,account_number,account_name, sys_type, parent_account_id) 
SELECT 20600,  '40500', 'Amortization Expenses',                                      0, finance.get_account_id_by_account_name('Expenses');
INSERT INTO finance.accounts(account_master_id,account_number,account_name, sys_type, parent_account_id) 
SELECT 20600,  '40600', 'Auto Expenses',                                              0, finance.get_account_id_by_account_name('Expenses');
INSERT INTO finance.accounts(account_master_id,account_number,account_name, sys_type, parent_account_id) 
SELECT 20600,  '40700', 'Bad Debt Expenses',                                          0, finance.get_account_id_by_account_name('Expenses');
INSERT INTO finance.accounts(account_master_id,account_number,account_name, sys_type, parent_account_id) 
SELECT 20700,  '40800', 'Bank Fees',                                                  0, finance.get_account_id_by_account_name('Expenses');
INSERT INTO finance.accounts(account_master_id,account_number,account_name, sys_type, parent_account_id) 
SELECT 20600,  '40900', 'Cash Over and Short',                                        0, finance.get_account_id_by_account_name('Expenses');
INSERT INTO finance.accounts(account_master_id,account_number,account_name, sys_type, parent_account_id) 
SELECT 20600,  '41000', 'Charitable Contributions Expenses',                          0, finance.get_account_id_by_account_name('Expenses');
INSERT INTO finance.accounts(account_master_id,account_number,account_name, sys_type, parent_account_id) 
SELECT 20700,  '41100', 'Commissions and Fees Expenses',                              0, finance.get_account_id_by_account_name('Expenses');
INSERT INTO finance.accounts(account_master_id,account_number,account_name, sys_type, parent_account_id) 
SELECT 20600,  '41200', 'Depreciation Expenses',                                      0, finance.get_account_id_by_account_name('Expenses');
INSERT INTO finance.accounts(account_master_id,account_number,account_name, sys_type, parent_account_id) 
SELECT 20600,  '41300', 'Dues and Subscriptions Expenses',                            0, finance.get_account_id_by_account_name('Expenses');
INSERT INTO finance.accounts(account_master_id,account_number,account_name, sys_type, parent_account_id) 
SELECT 20600,  '41400', 'Employee Benefit Expenses',                                  0, finance.get_account_id_by_account_name('Expenses');
INSERT INTO finance.accounts(account_master_id,account_number,account_name, sys_type, parent_account_id) 
SELECT 20600,  '41410', 'Employee Benefit Expenses-Health Insurance',                 0, finance.get_account_id_by_account_name('Employee Benefit Expenses');
INSERT INTO finance.accounts(account_master_id,account_number,account_name, sys_type, parent_account_id) 
SELECT 20600,  '41420', 'Employee Benefit Expenses-Pension Plans',                    0, finance.get_account_id_by_account_name('Employee Benefit Expenses');
INSERT INTO finance.accounts(account_master_id,account_number,account_name, sys_type, parent_account_id) 
SELECT 20600,  '41430', 'Employee Benefit Expenses-Profit Sharing Plan',              0, finance.get_account_id_by_account_name('Employee Benefit Expenses');
INSERT INTO finance.accounts(account_master_id,account_number,account_name, sys_type, parent_account_id) 
SELECT 20600,  '41440', 'Employee Benefit Expenses-Other',                            0, finance.get_account_id_by_account_name('Employee Benefit Expenses');
INSERT INTO finance.accounts(account_master_id,account_number,account_name, sys_type, parent_account_id) 
SELECT 20600,  '41500', 'Freight Expenses',                                           0, finance.get_account_id_by_account_name('Expenses');
INSERT INTO finance.accounts(account_master_id,account_number,account_name, sys_type, parent_account_id) 
SELECT 20600,  '41600', 'Gifts Expenses',                                             0, finance.get_account_id_by_account_name('Expenses');
INSERT INTO finance.accounts(account_master_id,account_number,account_name, sys_type, parent_account_id) 
SELECT 20800,  '41700', 'Income Tax Expenses',                                        0, finance.get_account_id_by_account_name('Expenses');
INSERT INTO finance.accounts(account_master_id,account_number,account_name, sys_type, parent_account_id) 
SELECT 20800,  '41710', 'Income Tax Expenses-Federal',                                0, finance.get_account_id_by_account_name('Income Tax Expenses');
INSERT INTO finance.accounts(account_master_id,account_number,account_name, sys_type, parent_account_id) 
SELECT 20800,  '41720', 'Income Tax Expenses-State',                                  0, finance.get_account_id_by_account_name('Income Tax Expenses');
INSERT INTO finance.accounts(account_master_id,account_number,account_name, sys_type, parent_account_id) 
SELECT 20800,  '41730', 'Income Tax Expenses-Local',                                  0, finance.get_account_id_by_account_name('Income Tax Expenses');
INSERT INTO finance.accounts(account_master_id,account_number,account_name, sys_type, parent_account_id) 
SELECT 20600,  '41800', 'Insurance Expenses',                                         0, finance.get_account_id_by_account_name('Expenses');
INSERT INTO finance.accounts(account_master_id,account_number,account_name, sys_type, parent_account_id) 
SELECT 20600,  '41810', 'Insurance Expenses-Product Liability',                       0, finance.get_account_id_by_account_name('Insurance Expenses');
INSERT INTO finance.accounts(account_master_id,account_number,account_name, sys_type, parent_account_id) 
SELECT 20600,  '41820', 'Insurance Expenses-Vehicle',                                 0, finance.get_account_id_by_account_name('Insurance Expenses');
INSERT INTO finance.accounts(account_master_id,account_number,account_name, sys_type, parent_account_id) 
SELECT 20701,  '41900', 'Interest Expenses',                                          0, finance.get_account_id_by_account_name('Expenses');
INSERT INTO finance.accounts(account_master_id,account_number,account_name, sys_type, parent_account_id) 
SELECT 20600,  '42000', 'Laundry and Dry Cleaning Expenses',                          0, finance.get_account_id_by_account_name('Expenses');
INSERT INTO finance.accounts(account_master_id,account_number,account_name, sys_type, parent_account_id) 
SELECT 20600,  '42100', 'Legal and Professional Expenses',                            0, finance.get_account_id_by_account_name('Expenses');
INSERT INTO finance.accounts(account_master_id,account_number,account_name, sys_type, parent_account_id) 
SELECT 20600,  '42200', 'Licenses Expenses',                                          0, finance.get_account_id_by_account_name('Expenses');
INSERT INTO finance.accounts(account_master_id,account_number,account_name, sys_type, parent_account_id) 
SELECT 20600,  '42300', 'Loss on NSF Checks',                                         0, finance.get_account_id_by_account_name('Expenses');
INSERT INTO finance.accounts(account_master_id,account_number,account_name, sys_type, parent_account_id) 
SELECT 20600,  '42400', 'Maintenance Expenses',                                       0, finance.get_account_id_by_account_name('Expenses');
INSERT INTO finance.accounts(account_master_id,account_number,account_name, sys_type, parent_account_id) 
SELECT 20600,  '42500', 'Meals and Entertainment Expenses',                           0, finance.get_account_id_by_account_name('Expenses');
INSERT INTO finance.accounts(account_master_id,account_number,account_name, sys_type, parent_account_id) 
SELECT 20600,  '42600', 'Office Expenses',                                            0, finance.get_account_id_by_account_name('Expenses');
INSERT INTO finance.accounts(account_master_id,account_number,account_name, sys_type, parent_account_id) 
SELECT 20600,  '42700', 'Payroll Tax Expenses',                                       0, finance.get_account_id_by_account_name('Expenses');
INSERT INTO finance.accounts(account_master_id,account_number,account_name, sys_type, parent_account_id) 
SELECT 20700,  '42800', 'Penalties and Fines Expenses',                               0, finance.get_account_id_by_account_name('Expenses');
INSERT INTO finance.accounts(account_master_id,account_number,account_name, sys_type, parent_account_id) 
SELECT 20600,  '42900', 'Other Taxe Expenses',                                        0, finance.get_account_id_by_account_name('Expenses');
INSERT INTO finance.accounts(account_master_id,account_number,account_name, sys_type, parent_account_id) 
SELECT 20600,  '43000', 'Postage Expenses',                                           0, finance.get_account_id_by_account_name('Expenses');
INSERT INTO finance.accounts(account_master_id,account_number,account_name, sys_type, parent_account_id) 
SELECT 20600,  '43100', 'Rent or Lease Expenses',                                     0, finance.get_account_id_by_account_name('Expenses');
INSERT INTO finance.accounts(account_master_id,account_number,account_name, sys_type, parent_account_id) 
SELECT 20600,  '43200', 'Repair and Maintenance Expenses',                            0, finance.get_account_id_by_account_name('Expenses');
INSERT INTO finance.accounts(account_master_id,account_number,account_name, sys_type, parent_account_id) 
SELECT 20600,  '43210', 'Repair and Maintenance Expenses-Office',                     0, finance.get_account_id_by_account_name('Repair and Maintenance Expenses');
INSERT INTO finance.accounts(account_master_id,account_number,account_name, sys_type, parent_account_id) 
SELECT 20600,  '43220', 'Repair and Maintenance Expenses-Vehicle',                    0, finance.get_account_id_by_account_name('Repair and Maintenance Expenses');
INSERT INTO finance.accounts(account_master_id,account_number,account_name, sys_type, parent_account_id) 
SELECT 20600,  '43300', 'Supplies Expenses-Office',                                   0, finance.get_account_id_by_account_name('Expenses');
INSERT INTO finance.accounts(account_master_id,account_number,account_name, sys_type, parent_account_id) 
SELECT 20600,  '43400', 'Telephone Expenses',                                         0, finance.get_account_id_by_account_name('Expenses');
INSERT INTO finance.accounts(account_master_id,account_number,account_name, sys_type, parent_account_id) 
SELECT 20600,  '43500', 'Training Expenses',                                          0, finance.get_account_id_by_account_name('Expenses');
INSERT INTO finance.accounts(account_master_id,account_number,account_name, sys_type, parent_account_id) 
SELECT 20600,  '43600', 'Travel Expenses',                                            0, finance.get_account_id_by_account_name('Expenses');
INSERT INTO finance.accounts(account_master_id,account_number,account_name, sys_type, parent_account_id) 
SELECT 20600,  '43700', 'Salary Expenses',                                            0, finance.get_account_id_by_account_name('Expenses');
INSERT INTO finance.accounts(account_master_id,account_number,account_name, sys_type, parent_account_id) 
SELECT 20600,  '43800', 'Wages Expenses',                                             0, finance.get_account_id_by_account_name('Expenses');
INSERT INTO finance.accounts(account_master_id,account_number,account_name, sys_type, parent_account_id) 
SELECT 20600,  '43900', 'Utilities Expenses',                                         0, finance.get_account_id_by_account_name('Expenses');
INSERT INTO finance.accounts(account_master_id,account_number,account_name, sys_type, parent_account_id) 
SELECT 20600,  '44000', 'Other Expenses',                                             0, finance.get_account_id_by_account_name('Expenses');
INSERT INTO finance.accounts(account_master_id,account_number,account_name, sys_type, parent_account_id) 
SELECT 20600,  '44100', 'Gain/Loss on Sale of Assets',                                0, finance.get_account_id_by_account_name('Expenses');


UPDATE finance.accounts
SET currency_code='USD';

GO

ALTER TABLE finance.accounts
ALTER column currency_code national character varying(12) NOT NULL;

GO

INSERT INTO finance.cost_centers(cost_center_code, cost_center_name)
SELECT 'DEF', 'Default'                             UNION ALL
SELECT 'GEN', 'General Administration'              UNION ALL
SELECT 'HUM', 'Human Resources'                     UNION ALL
SELECT 'SCC', 'Support & Customer Care'             UNION ALL
SELECT 'GAE', 'Guest Accomodation & Entertainment'  UNION ALL
SELECT 'MKT', 'Marketing & Promotion'               UNION ALL
SELECT 'SAL', 'Sales & Billing'                     UNION ALL
SELECT 'FIN', 'Finance & Accounting';

INSERT INTO finance.cash_repositories(office_id, cash_repository_code, cash_repository_name)
SELECT core.get_office_id_by_office_name('Default'), 'CAC', 'Cash in Counter' UNION ALL
SELECT core.get_office_id_by_office_name('Default'), 'CAV', 'Cash in Vault';

INSERT INTO finance.journal_verification_policy(user_id, office_id, can_verify, verification_limit, can_self_verify, self_verification_limit, effective_from, ends_on, is_active)
SELECT
    account.users.user_id,
    core.offices.office_id,
    1,
    0,
    1,
    0,
    '1-1-2000',
    '1-1-2100',
    1
FROM account.users
CROSS JOIN core.offices
WHERE account.users.role_id = 9999;

INSERT INTO finance.auto_verification_policy(user_id, office_id, verification_limit, effective_from, ends_on, is_active)
SELECT
    account.users.user_id,
    core.offices.office_id,
    0,
    '1-1-2000',
    '1-1-2100',
    1
FROM account.users
CROSS JOIN core.offices
WHERE account.users.role_id = 9999;



INSERT INTO finance.fiscal_year (fiscal_year_code, fiscal_year_name, starts_from, ends_on, office_id) 
VALUES ('FY1617', 'FY 2016/2017', '2016-07-17', '2017-07-16', core.get_office_id_by_office_name('Default'));

INSERT INTO finance.frequency_setups (fiscal_year_code, frequency_setup_code, value_date, frequency_id, office_id) 
SELECT 'FY1617', 'Jul-Aug', '2016-08-16', 2, core.get_office_id_by_office_name('Default') UNION ALL
SELECT 'FY1617', 'Aug-Sep', '2016-09-16', 2, core.get_office_id_by_office_name('Default') UNION ALL
SELECT 'FY1617', 'Sep-Oc',  '2016-10-17', 3, core.get_office_id_by_office_name('Default') UNION ALL
SELECT 'FY1617', 'Oct-Nov', '2016-11-16', 2, core.get_office_id_by_office_name('Default') UNION ALL
SELECT 'FY1617', 'Nov-Dec', '2016-12-15', 2, core.get_office_id_by_office_name('Default') UNION ALL
SELECT 'FY1617', 'Dec-Jan', '2017-01-14', 4, core.get_office_id_by_office_name('Default') UNION ALL
SELECT 'FY1617', 'Jan-Feb', '2017-02-12', 2, core.get_office_id_by_office_name('Default') UNION ALL
SELECT 'FY1617', 'Feb-Mar', '2017-03-14', 2, core.get_office_id_by_office_name('Default') UNION ALL
SELECT 'FY1617', 'Mar-Apr', '2017-04-13', 3, core.get_office_id_by_office_name('Default') UNION ALL
SELECT 'FY1617', 'Apr-May', '2017-05-14', 2, core.get_office_id_by_office_name('Default') UNION ALL
SELECT 'FY1617', 'May-Jun', '2017-06-15', 2, core.get_office_id_by_office_name('Default') UNION ALL
SELECT 'FY1617', 'Jun-Jul', '2017-07-16', 5, core.get_office_id_by_office_name('Default');

INSERT INTO finance.tax_setups(office_id, income_tax_rate, income_tax_account_id, sales_tax_rate, sales_tax_account_id)
SELECT office_id, 25, finance.get_account_id_by_account_number('20770'), 13, finance.get_account_id_by_account_number('20710')
FROM core.offices;


EXECUTE finance.create_card_type 1, 'CRC', 'Credit Card';
EXECUTE finance.create_card_type 2, 'DRC', 'Debit Card';
EXECUTE finance.create_card_type 3, 'CHC', 'Charge Card';
EXECUTE finance.create_card_type 4, 'ATM', 'ATM Card';
EXECUTE finance.create_card_type 5, 'SVC', 'Store-value Card';
EXECUTE finance.create_card_type 6, 'FLC', 'Fleet Card';
EXECUTE finance.create_card_type 7, 'GFC', 'Gift Card';
EXECUTE finance.create_card_type 8, 'SCR', 'Scrip';
EXECUTE finance.create_card_type 9, 'ELP', 'Electronic Purse';


EXECUTE finance.create_payment_card 'CR-VSA', 'Visa',                1;
EXECUTE finance.create_payment_card 'CR-AME', 'American Express',    1;
EXECUTE finance.create_payment_card 'CR-MAS', 'MasterCard',          1;
EXECUTE finance.create_payment_card 'DR-MAE', 'Maestro',             2;
EXECUTE finance.create_payment_card 'DR-MAS', 'MasterCard Debit',    2;
EXECUTE finance.create_payment_card 'DR-VSE', 'Visa Electron',       2;
EXECUTE finance.create_payment_card 'DR-VSD', 'Visa Debit',          2;
EXECUTE finance.create_payment_card 'DR-DEL', 'Delta',               2;




INSERT INTO finance.bank_accounts(bank_account_name, account_id, maintained_by_user_id, is_merchant_account, office_id, bank_name, bank_branch)
SELECT 'ABN AMRO Savings A/C', finance.get_account_id_by_account_number('10102'), 1, 0, core.get_office_id_by_office_name('Default'), 'ABN AMRO Bank', '';



--ROLLBACK TRANSACTION;


GO


