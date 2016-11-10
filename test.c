#include <assert.h>
#include <stdio.h>
#include <stdlib.h>
#include <setjmp.h>

static jmp_buf jbuf;
static size_t allmem = 0;
static size_t maxmem = 0;

static void *debug_allocf(void *ud, void *ptr, size_t ns, size_t os) {
    void *newptr = NULL;
    (void)ud;
    allmem += ns;
    allmem -= os;
    if (maxmem < allmem) maxmem = allmem;
    if (ns == 0) free(ptr);
    else {
        newptr = realloc(ptr, ns);
        if (newptr == NULL) longjmp(jbuf, 1);
    }
#ifdef DEBUG_MEMORY
    printf("new(%p):\t+%d, old(%p):\t-%d\n", newptr, (int)ns, ptr, (int)os);
#endif
    return newptr;
}

#define AM_IMPLEMENTATION
#include "amoeba.h"

static void am_dumpkey(am_Symbol sym) {
    int ch = 'v';
    switch (sym.type) {
    case AM_EXTERNAL: ch = 'v'; break;
    case AM_SLACK:    ch = 's'; break;
    case AM_ERROR:    ch = 'e'; break;
    case AM_DUMMY:    ch = 'd'; break;
    }
    printf("%c%d", ch, (int)sym.id);
}

static void am_dumprow(am_Row *row) {
    am_Term *term = NULL;
    printf("%g", row->constant);
    while (am_nextentry(&row->terms, (am_Entry**)&term)) {
        double multiplier = term->multiplier;
        printf(" %c ", multiplier > 0.0 ? '+' : '-');
        if (multiplier < 0.0) multiplier = -multiplier;
        if (!am_approx(multiplier, 1.0))
            printf("%g*", multiplier);
        am_dumpkey(am_key(term));
    }
    printf("\n");
}

static void am_dumpsolver(am_Solver *solver) {
    am_Row *row = NULL;
    int idx = 0;
    printf("-------------------------------\n");
    printf("solver: ");
    am_dumprow(&solver->objective);
    printf("rows(%d):\n", (int)solver->rows.count);
    while (am_nextentry(&solver->rows, (am_Entry**)&row)) {
        printf("%d. ", ++idx);
        am_dumpkey(am_key(row));
        printf(" = ");
        am_dumprow(row);
    }
    printf("-------------------------------\n");
}

static void test_all(void) {
    am_Solver *solver;
    am_Variable *xl;
    am_Variable *xm;
    am_Variable *xr;
    am_Constraint *c1, *c2, *c3, *c4, *c5, *c6;
    int ret = setjmp(jbuf);
    printf("ret = %d\n", ret);
    if (ret < 0) {
        perror("setjmp");
        return;
    }
    else if (ret != 0) {
        printf("out of memory!\n");
        return;
    }

    solver = am_newsolver(debug_allocf, NULL);
    xl = am_newvariable(solver);
    xm = am_newvariable(solver);
    xr = am_newvariable(solver);

    c1 = am_newconstraint(solver, AM_REQUIRED);
    am_addterm(c1, xl, 1.0);
    am_setrelation(c1, AM_GREATEQUAL);
    ret = am_add(c1);
    assert(ret == AM_OK);
    am_dumpsolver(solver);

    c2 = am_newconstraint(solver, AM_REQUIRED);
    am_addterm(c2, xl, 1.0);
    am_setrelation(c2, AM_EQUAL);
    ret = am_add(c2);
    assert(ret == AM_OK);
    am_dumpsolver(solver);

    am_resetsolver(solver, 1);
    am_delconstraint(c1);
    am_delconstraint(c2);
    am_dumpsolver(solver);

    /* c1: 2*xm == xl + xr */
    c1 = am_newconstraint(solver, AM_REQUIRED);
    am_addterm(c1, xm, 2.0);
    am_setrelation(c1, AM_EQUAL);
    am_addterm(c1, xl, 1.0);
    am_addterm(c1, xr, 1.0);
    ret = am_add(c1);
    assert(ret == AM_OK);
    am_dumpsolver(solver);

    /* c2: xl + 10 <= xr */
    c2 = am_newconstraint(solver, AM_REQUIRED);
    am_addterm(c2, xl, 1.0);
    am_addconstant(c2, 10.0);
    am_setrelation(c2, AM_LESSEQUAL);
    am_addterm(c2, xr, 1.0);
    ret = am_add(c2);
    assert(ret == AM_OK);
    am_dumpsolver(solver);

    /* c3: xr <= 100 */
    c3 = am_newconstraint(solver, AM_REQUIRED);
    am_addterm(c3, xr, 1.0);
    am_setrelation(c3, AM_LESSEQUAL);
    am_addconstant(c3, 100.0);
    ret = am_add(c3);
    assert(ret == AM_OK);
    am_dumpsolver(solver);

    /* c4: xl >= 0 */
    c4 = am_newconstraint(solver, AM_REQUIRED);
    am_addterm(c4, xl, 1.0);
    am_setrelation(c4, AM_GREATEQUAL);
    am_addconstant(c4, 0.0);
    ret = am_add(c4);
    assert(ret == AM_OK);
    am_dumpsolver(solver);

    c5 = am_cloneconstraint(c4, AM_REQUIRED);
    ret = am_add(c5);
    assert(ret == AM_OK);
    am_dumpsolver(solver);
    am_remove(c5);

    c5 = am_newconstraint(solver, AM_REQUIRED);
    am_addterm(c5, xl, 1.0);
    am_setrelation(c5, AM_EQUAL);
    am_addconstant(c5, 0.0);
    ret = am_add(c5);
    assert(ret == AM_OK);

    c6 = am_cloneconstraint(c4, AM_REQUIRED);
    ret = am_add(c6);
    assert(ret == AM_OK);
    am_dumpsolver(solver);

    am_resetconstraint(c6);
    am_delconstraint(c6);

    am_remove(c1);
    am_remove(c2);
    am_remove(c3);
    am_remove(c4);
    am_dumpsolver(solver);
    ret |= am_add(c4);
    ret |= am_add(c3);
    ret |= am_add(c2);
    ret |= am_add(c1);
    assert(ret == AM_OK);

    am_resetsolver(solver, 0);
    am_resetsolver(solver, 1);
    printf("after reset\n");
    am_dumpsolver(solver);
    ret |= am_add(c1);
    ret |= am_add(c2);
    ret |= am_add(c3);
    ret |= am_add(c4);
    assert(ret == AM_OK);

    printf("after initialize\n");
    am_dumpsolver(solver);
    printf("xl: %f, xm: %f, xr: %f\n",
            am_value(xl),
            am_value(xm),
            am_value(xr));

    am_addedit(xm, AM_MEDIUM);
    am_dumpsolver(solver);
    printf("xl: %f, xm: %f, xr: %f\n",
            am_value(xl),
            am_value(xm),
            am_value(xr));

    printf("suggest to 0.0\n");
    am_suggest(xm, 0.0);
    am_dumpsolver(solver);
    printf("xl: %f, xm: %f, xr: %f\n",
            am_value(xl),
            am_value(xm),
            am_value(xr));

    printf("suggest to 70.0\n");
    am_suggest(xm, 70.0);
    am_dumpsolver(solver);

    printf("xl: %f, xm: %f, xr: %f\n",
            am_value(xl),
            am_value(xm),
            am_value(xr));

    am_deledit(xm);
    am_dumpsolver(solver);

    printf("xl: %f, xm: %f, xr: %f\n",
            am_value(xl),
            am_value(xm),
            am_value(xr));

    am_delsolver(solver);
    printf("allmem = %d\n", (int)allmem);
    printf("maxmem = %d\n", (int)maxmem);
    assert(allmem == 0);
}

static void test_binarytree(void) {
    am_Variable *arrX[1024], *arrY[1024];

    // Create set of rules to distribute vertexes of a binary tree like this one:
    //      0
    //     / \
    //    /   \
    //   1     2
    //  / \   / \
    // 3   4 5   6

    am_Solver *pSolver = am_newsolver(debug_allocf, NULL);

    /* Xroot=500, Yroot=10 */
    arrX[0] = am_newvariable(pSolver);
    arrY[0] = am_newvariable(pSolver);
    am_addedit(arrX[0], AM_STRONG);
    am_addedit(arrY[0], AM_STRONG);
    am_suggest(arrX[0], 500.0);
    am_suggest(arrY[0], 10.0);

    int nCurrentRowPointsCount = 1;
    int nCurrentRowFirstPointIndex = 0;

    am_Constraint *pC;
    int nResult;
    int nRows = 3;
    for (int nRow = 1; nRow < nRows; nRow++) {
        int nPreviousRowFirstPointIndex = nCurrentRowFirstPointIndex;
        int nParentPoint = 0;
        nCurrentRowFirstPointIndex += nCurrentRowPointsCount;
        nCurrentRowPointsCount *= 2;
        for (int nPoint = 0; nPoint < nCurrentRowPointsCount; nPoint++) {
            arrX[nCurrentRowFirstPointIndex + nPoint] = am_newvariable(pSolver);
            arrY[nCurrentRowFirstPointIndex + nPoint] = am_newvariable(pSolver);

            // Ycur = Yprev_row + 10
            pC = am_newconstraint(pSolver, AM_REQUIRED);
            am_addterm(pC, arrY[nCurrentRowFirstPointIndex + nPoint], 1.0);
            am_setrelation(pC, AM_EQUAL);
            am_addterm(pC, arrY[nCurrentRowFirstPointIndex - 1], 1.0);
            am_addconstant(pC, 10.0);
            nResult = am_add(pC);
            assert(nResult == AM_OK);

            if (nPoint > 0) {
                // Xcur = XPrev + 10
                pC = am_newconstraint(pSolver, AM_REQUIRED);
                am_addterm(pC, arrX[nCurrentRowFirstPointIndex + nPoint], 1.0);
                am_setrelation(pC, AM_EQUAL);
                am_addterm(pC, arrX[nCurrentRowFirstPointIndex + nPoint - 1], 1.0);
                am_addconstant(pC, 10.0);
                nResult = am_add(pC);
                assert(nResult == AM_OK);
            }

            // 3rd call of this "if" causes "Unsatisfied" constraint and 
            // "Assertion failed at amoeba.h line 935"
            if ((nPoint % 2) == 1) {
                // Xparent = 0.5 * Xcur + 0.5 * Xprev
                pC = am_newconstraint(pSolver, AM_REQUIRED);
                am_addterm(pC, arrX[nPreviousRowFirstPointIndex + nParentPoint], 1.0);
                am_setrelation(pC, AM_EQUAL);
                am_addterm(pC, arrX[nCurrentRowFirstPointIndex + nPoint], 0.5);
                am_addterm(pC, arrX[nCurrentRowFirstPointIndex + nPoint - 1], 0.5);
                nResult = am_add(pC);
                // assert(nResult == AM_OK);

                nParentPoint++;
            }
        }

        /*		// By uncommenting this code it's possible to make correct constraints 
        // X0 = 0.5 * Xrightmost + 0.5 * Xleftmost
        pC = am_newconstraint(pSolver, AM_REQUIRED);
        am_addterm(pC, arrX[0], 1.0);
        am_setrelation(pC, AM_EQUAL);
        am_addterm(pC, arrX[nCurrentRowFirstPointIndex + nCurrentRowPointsCount - 1], 0.5);
        am_addterm(pC, arrX[nCurrentRowFirstPointIndex], 0.5);
        nResult = am_add(pSolver, pC);
        assert(nResult == AM_OK);
        */
    }

    am_dumpsolver(pSolver);

    int nLastPointIndex = nCurrentRowFirstPointIndex + nCurrentRowPointsCount - 1;
    for (int i = 0; i <= nLastPointIndex; i++) {
        printf("Point %d: (%f, %f)\n", i, am_value(arrX[i]), am_value(arrY[i]));
    }

    am_delsolver(pSolver);
    printf("allmem = %d\n", (int)allmem);
    printf("maxmem = %d\n", (int)maxmem);
    assert(allmem == 0);
}

static void test_unbounded(void) {
    am_Solver *solver;
    am_Variable *x;
    am_Constraint *c1, *c2;
    int ret = setjmp(jbuf);
    printf("ret = %d\n", ret);
    if (ret < 0) {
        perror("setjmp");
        return;
    }
    else if (ret != 0) {
        printf("out of memory!\n");
        return;
    }

    solver = am_newsolver(debug_allocf, NULL);
    x = am_newvariable(solver);

    c1 = am_newconstraint(solver, AM_REQUIRED);
    am_addterm(c1, x, 1.0);
    am_setrelation(c1, AM_GREATEQUAL);
    am_addconstant(c1, 10);
    ret = am_add(c1);
    assert(ret == AM_OK);
    am_dumpsolver(solver);

    c2 = am_newconstraint(solver, AM_REQUIRED);
    am_addterm(c2, x, 1.0);
    am_setrelation(c2, AM_EQUAL);
    ret = am_add(c2);
    assert(ret == AM_UNBOUND);
    am_dumpsolver(solver);

    printf("x: %f\n", am_value(x));

    am_delsolver(solver);
    printf("allmem = %d\n", (int)allmem);
    printf("maxmem = %d\n", (int)maxmem);
    assert(allmem == 0);
}

int main(void)
{
    test_binarytree();
    test_unbounded();
    test_all();
}
