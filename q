GITWORKFLOWS(7)                                                                     Git Manual                                                                    GITWORKFLOWS(7)

NNAAMMEE
       gitworkflows - An overview of recommended workflows with Git

SSYYNNOOPPSSIISS
       git *

DDEESSCCRRIIPPTTIIOONN
       This document attempts to write down and motivate some of the workflow elements used for ggiitt..ggiitt itself. Many ideas apply in general, though the full workflow is rarely
       required for smaller projects with fewer people involved.

       We formulate a set of _r_u_l_e_s for quick reference, while the prose tries to motivate each of them. Do not always take them literally; you should value good reasons for your
       actions higher than manpages such as this one.

SSEEPPAARRAATTEE CCHHAANNGGEESS
       As a general rule, you should try to split your changes into small logical steps, and commit each of them. They should be consistent, working independently of any later
       commits, pass the test suite, etc. This makes the review process much easier, and the history much more useful for later inspection and analysis, for example with ggiitt--
       bbllaammee(1) and ggiitt--bbiisseecctt(1).

       To achieve this, try to split your work into small steps from the very beginning. It is always easier to squash a few commits together than to split one big commit into
       several. Don’t be afraid of making too small or imperfect steps along the way. You can always go back later and edit the commits with ggiitt rreebbaassee ----iinntteerraaccttiivvee before you
       publish them. You can use ggiitt ssttaasshh ppuusshh ----kkeeeepp--iinnddeexx to run the test suite independent of other uncommitted changes; see the EXAMPLES section of ggiitt--ssttaasshh(1).

MMAANNAAGGIINNGG BBRRAANNCCHHEESS
       There are two main tools that can be used to include changes from one branch on another: ggiitt--mmeerrggee(1) and ggiitt--cchheerrrryy--ppiicckk(1).

       Merges have many advantages, so we try to solve as many problems as possible with merges alone. Cherry-picking is still occasionally useful; see "Merging upwards" below
       for an example.

       Most importantly, merging works at the branch level, while cherry-picking works at the commit level. This means that a merge can carry over the changes from 1, 10, or
       1000 commits with equal ease, which in turn means the workflow scales much better to a large number of contributors (and contributions). Merges are also easier to
       understand because a merge commit is a "promise" that all changes from all its parents are now included.

       There is a tradeoff of course: merges require a more careful branch management. The following subsections discuss the important points.

   GGrraadduuaattiioonn
       As a given feature goes from experimental to stable, it also "graduates" between the corresponding branches of the software. ggiitt..ggiitt uses the following _i_n_t_e_g_r_a_t_i_o_n
       _b_r_a_n_c_h_e_s:

       •   _m_a_i_n_t tracks the commits that should go into the next "maintenance release", i.e., update of the last released stable version;

       •   _m_a_s_t_e_r tracks the commits that should go into the next release;

       •   _n_e_x_t is intended as a testing branch for topics being tested for stability for master.

       There is a fourth official branch that is used slightly differently:

       •   _s_e_e_n (patches seen by the maintainer) is an integration branch for things that are not quite ready for inclusion yet (see "Integration Branches" below).

       Each of the four branches is usually a direct descendant of the one above it.

       Conceptually, the feature enters at an unstable branch (usually _n_e_x_t or _s_e_e_n), and "graduates" to _m_a_s_t_e_r for the next release once it is considered stable enough.

   MMeerrggiinngg uuppwwaarrddss
       The "downwards graduation" discussed above cannot be done by actually merging downwards, however, since that would merge _a_l_l changes on the unstable branch into the
       stable one. Hence the following:

       EExxaammppllee 11.. MMeerrggee uuppwwaarrddss

       Always commit your fixes to the oldest supported branch that requires them. Then (periodically) merge the integration branches upwards into each other.

       This gives a very controlled flow of fixes. If you notice that you have applied a fix to e.g. _m_a_s_t_e_r that is also required in _m_a_i_n_t, you will need to cherry-pick it
       (using ggiitt--cchheerrrryy--ppiicckk(1)) downwards. This will happen a few times and is nothing to worry about unless you do it very frequently.

   TTooppiicc bbrraanncchheess
       Any nontrivial feature will require several patches to implement, and may get extra bugfixes or improvements during its lifetime.

       Committing everything directly on the integration branches leads to many problems: Bad commits cannot be undone, so they must be reverted one by one, which creates
       confusing histories and further error potential when you forget to revert part of a group of changes. Working in parallel mixes up the changes, creating further
       confusion.

       Use of "topic branches" solves these problems. The name is pretty self explanatory, with a caveat that comes from the "merge upwards" rule above:

       EExxaammppllee 22.. TTooppiicc bbrraanncchheess

       Make a side branch for every topic (feature, bugfix, ...). Fork it off at the oldest integration branch that you will eventually want to merge it into.

       Many things can then be done very naturally:

       •   To get the feature/bugfix into an integration branch, simply merge it. If the topic has evolved further in the meantime, merge again. (Note that you do not
           necessarily have to merge it to the oldest integration branch first. For example, you can first merge a bugfix to _n_e_x_t, give it some testing time, and merge to _m_a_i_n_t
           when you know it is stable.)

       •   If you find you need new features from the branch _o_t_h_e_r to continue working on your topic, merge _o_t_h_e_r to _t_o_p_i_c. (However, do not do this "just habitually", see
           below.)

       •   If you find you forked off the wrong branch and want to move it "back in time", use ggiitt--rreebbaassee(1).

       Note that the last point clashes with the other two: a topic that has been merged elsewhere should not be rebased. See the section on RECOVERING FROM UPSTREAM REBASE in
       ggiitt--rreebbaassee(1).

       We should point out that "habitually" (regularly for no real reason) merging an integration branch into your topics — and by extension, merging anything upstream into
       anything downstream on a regular basis — is frowned upon:

       EExxaammppllee 33.. MMeerrggee ttoo ddoowwnnssttrreeaamm oonnllyy aatt wweellll--ddeeffiinneedd ppooiinnttss

       Do not merge to downstream except with a good reason: upstream API changes affect your branch; your branch no longer merges to upstream cleanly; etc.

       Otherwise, the topic that was merged to suddenly contains more than a single (well-separated) change. The many resulting small merges will greatly clutter up history.
       Anyone who later investigates the history of a file will have to find out whether that merge affected the topic in development. An upstream might even inadvertently be
       merged into a "more stable" branch. And so on.

   TThhrrooww--aawwaayy iinntteeggrraattiioonn
       If you followed the last paragraph, you will now have many small topic branches, and occasionally wonder how they interact. Perhaps the result of merging them does not
       even work? But on the other hand, we want to avoid merging them anywhere "stable" because such merges cannot easily be undone.

       The solution, of course, is to make a merge that we can undo: merge into a throw-away branch.

       EExxaammppllee 44.. TThhrrooww--aawwaayy iinntteeggrraattiioonn bbrraanncchheess

       To test the interaction of several topics, merge them into a throw-away branch. You must never base any work on such a branch!

       If you make it (very) clear that this branch is going to be deleted right after the testing, you can even publish this branch, for example to give the testers a chance to
       work with it, or other developers a chance to see if their in-progress work will be compatible. ggiitt..ggiitt has such an official throw-away integration branch called _s_e_e_n.

   BBrraanncchh mmaannaaggeemmeenntt ffoorr aa rreelleeaassee
       Assuming you are using the merge approach discussed above, when you are releasing your project you will need to do some additional branch management work.

       A feature release is created from the _m_a_s_t_e_r branch, since _m_a_s_t_e_r tracks the commits that should go into the next feature release.

       The _m_a_s_t_e_r branch is supposed to be a superset of _m_a_i_n_t. If this condition does not hold, then _m_a_i_n_t contains some commits that are not included on _m_a_s_t_e_r. The fixes
       represented by those commits will therefore not be included in your feature release.

       To verify that _m_a_s_t_e_r is indeed a superset of _m_a_i_n_t, use git log:

       EExxaammppllee 55.. VVeerriiffyy _m_a_s_t_e_r is a superset of _m_a_i_n_t

       ggiitt lloogg mmaasstteerr....mmaaiinntt

       This command should not list any commits. Otherwise, check out _m_a_s_t_e_r and merge _m_a_i_n_t into it.

       Now you can proceed with the creation of the feature release. Apply a tag to the tip of _m_a_s_t_e_r indicating the release version:

       EExxaammppllee 66.. RReelleeaassee ttaaggggiinngg

       ggiitt ttaagg --ss --mm ""GGiitt XX..YY..ZZ"" vvXX..YY..ZZ mmaasstteerr

       You need to push the new tag to a public Git server (see "DISTRIBUTED WORKFLOWS" below). This makes the tag available to others tracking your project. The push could also
       trigger a post-update hook to perform release-related items such as building release tarballs and preformatted documentation pages.

       Similarly, for a maintenance release, _m_a_i_n_t is tracking the commits to be released. Therefore, in the steps above simply tag and push _m_a_i_n_t rather than _m_a_s_t_e_r.

   MMaaiinntteennaannccee bbrraanncchh mmaannaaggeemmeenntt aafftteerr aa ffeeaattuurree rreelleeaassee
       After a feature release, you need to manage your maintenance branches.

       First, if you wish to continue to release maintenance fixes for the feature release made before the recent one, then you must create another branch to track commits for
       that previous release.

       To do this, the current maintenance branch is copied to another branch named with the previous release version number (e.g. maint-X.Y.(Z-1) where X.Y.Z is the current
       release).

       EExxaammppllee 77.. CCooppyy mmaaiinntt

       ggiitt bbrraanncchh mmaaiinntt--XX..YY..((ZZ--11)) mmaaiinntt

       The _m_a_i_n_t branch should now be fast-forwarded to the newly released code so that maintenance fixes can be tracked for the current release:

       EExxaammppllee 88.. UUppddaattee mmaaiinntt ttoo nneeww rreelleeaassee

       •   ggiitt cchheecckkoouutt mmaaiinntt

       •   ggiitt mmeerrggee ----ffff--oonnllyy mmaasstteerr

       If the merge fails because it is not a fast-forward, then it is possible some fixes on _m_a_i_n_t were missed in the feature release. This will not happen if the content of
       the branches was verified as described in the previous section.

   BBrraanncchh mmaannaaggeemmeenntt ffoorr nneexxtt aanndd sseeeenn aafftteerr aa ffeeaattuurree rreelleeaassee
       After a feature release, the integration branch _n_e_x_t may optionally be rewound and rebuilt from the tip of _m_a_s_t_e_r using the surviving topics on _n_e_x_t:

       EExxaammppllee 99.. RReewwiinndd aanndd rreebbuuiilldd nneexxtt

       •   ggiitt sswwiittcchh --CC nneexxtt mmaasstteerr

       •   ggiitt mmeerrggee aaii//ttooppiicc__iinn__nneexxtt11

       •   ggiitt mmeerrggee aaii//ttooppiicc__iinn__nneexxtt22

       •   ...

       The advantage of doing this is that the history of _n_e_x_t will be clean. For example, some topics merged into _n_e_x_t may have initially looked promising, but were later found
       to be undesirable or premature. In such a case, the topic is reverted out of _n_e_x_t but the fact remains in the history that it was once merged and reverted. By recreating
       _n_e_x_t, you give another incarnation of such topics a clean slate to retry, and a feature release is a good point in history to do so.

       If you do this, then you should make a public announcement indicating that _n_e_x_t was rewound and rebuilt.

       The same rewind and rebuild process may be followed for _s_e_e_n. A public announcement is not necessary since _s_e_e_n is a throw-away branch, as described above.

DDIISSTTRRIIBBUUTTEEDD WWOORRKKFFLLOOWWSS
       After the last section, you should know how to manage topics. In general, you will not be the only person working on the project, so you will have to share your work.

       Roughly speaking, there are two important workflows: merge and patch. The important difference is that the merge workflow can propagate full history, including merges,
       while patches cannot. Both workflows can be used in parallel: in ggiitt..ggiitt, only subsystem maintainers use the merge workflow, while everyone else sends patches.

       Note that the maintainer(s) may impose restrictions, such as "Signed-off-by" requirements, that all commits/patches submitted for inclusion must adhere to. Consult your
       project’s documentation for more information.

   MMeerrggee wwoorrkkffllooww
       The merge workflow works by copying branches between upstream and downstream. Upstream can merge contributions into the official history; downstream base their work on
       the official history.

       There are three main tools that can be used for this:

       •   ggiitt--ppuusshh(1) copies your branches to a remote repository, usually to one that can be read by all involved parties;

       •   ggiitt--ffeettcchh(1) that copies remote branches to your repository; and

       •   ggiitt--ppuullll(1) that does fetch and merge in one go.

       Note the last point. Do _n_o_t use _g_i_t _p_u_l_l unless you actually want to merge the remote branch.

       Getting changes out is easy:

       EExxaammppllee 1100.. PPuusshh//ppuullll:: PPuubblliisshhiinngg bbrraanncchheess//ttooppiiccss

       ggiitt ppuusshh <<rreemmoottee>> <<bbrraanncchh>> and tell everyone where they can fetch from.

       You will still have to tell people by other means, such as mail. (Git provides the ggiitt--rreeqquueesstt--ppuullll(1) to send preformatted pull requests to upstream maintainers to
       simplify this task.)

       If you just want to get the newest copies of the integration branches, staying up to date is easy too:

       EExxaammppllee 1111.. PPuusshh//ppuullll:: SSttaayyiinngg uupp ttoo ddaattee

       Use ggiitt ffeettcchh <<rreemmoottee>> or ggiitt rreemmoottee uuppddaattee to stay up to date.

       Then simply fork your topic branches from the stable remotes as explained earlier.

       If you are a maintainer and would like to merge other people’s topic branches to the integration branches, they will typically send a request to do so by mail. Such a
       request looks like

           Please pull from
               <url> <branch>

       In that case, _g_i_t _p_u_l_l can do the fetch and merge in one go, as follows.

       EExxaammppllee 1122.. PPuusshh//ppuullll:: MMeerrggiinngg rreemmoottee ttooppiiccss

       ggiitt ppuullll <<uurrll>> <<bbrraanncchh>>

       Occasionally, the maintainer may get merge conflicts when they try to pull changes from downstream. In this case, they can ask downstream to do the merge and resolve the
       conflicts themselves (perhaps they will know better how to resolve them). It is one of the rare cases where downstream _s_h_o_u_l_d merge from upstream.

   PPaattcchh wwoorrkkffllooww
       If you are a contributor that sends changes upstream in the form of emails, you should use topic branches as usual (see above). Then use ggiitt--ffoorrmmaatt--ppaattcchh(1) to generate
       the corresponding emails (highly recommended over manually formatting them because it makes the maintainer’s life easier).

       EExxaammppllee 1133.. ffoorrmmaatt--ppaattcchh//aamm:: PPuubblliisshhiinngg bbrraanncchheess//ttooppiiccss

       •   ggiitt ffoorrmmaatt--ppaattcchh --MM uuppssttrreeaamm....ttooppiicc to turn them into preformatted patch files

       •   ggiitt sseenndd--eemmaaiill ----ttoo==<<rreecciippiieenntt>> <<ppaattcchheess>>

       See the ggiitt--ffoorrmmaatt--ppaattcchh(1) and ggiitt--sseenndd--eemmaaiill(1) manpages for further usage notes.

       If the maintainer tells you that your patch no longer applies to the current upstream, you will have to rebase your topic (you cannot use a merge because you cannot
       format-patch merges):

       EExxaammppllee 1144.. ffoorrmmaatt--ppaattcchh//aamm:: KKeeeeppiinngg ttooppiiccss uupp ttoo ddaattee

       ggiitt ppuullll ----rreebbaassee <<uurrll>> <<bbrraanncchh>>

       You can then fix the conflicts during the rebase. Presumably you have not published your topic other than by mail, so rebasing it is not a problem.

       If you receive such a patch series (as maintainer, or perhaps as a reader of the mailing list it was sent to), save the mails to files, create a new topic branch and use
       _g_i_t _a_m to import the commits:

       EExxaammppllee 1155.. ffoorrmmaatt--ppaattcchh//aamm:: IImmppoorrttiinngg ppaattcchheess

       ggiitt aamm << ppaattcchh

       One feature worth pointing out is the three-way merge, which can help if you get conflicts: ggiitt aamm --33 will use index information contained in patches to figure out the
       merge base. See ggiitt--aamm(1) for other options.

SSEEEE AALLSSOO
       ggiittttuuttoorriiaall(7), ggiitt--ppuusshh(1), ggiitt--ppuullll(1), ggiitt--mmeerrggee(1), ggiitt--rreebbaassee(1), ggiitt--ffoorrmmaatt--ppaattcchh(1), ggiitt--sseenndd--eemmaaiill(1), ggiitt--aamm(1)

GGIITT
       Part of the ggiitt(1) suite

Git 2.34.1                                                                          07/07/2023                                                                    GITWORKFLOWS(7)
