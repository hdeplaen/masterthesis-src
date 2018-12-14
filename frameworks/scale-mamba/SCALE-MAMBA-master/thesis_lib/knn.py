class KNN(object):
    def __init__(self, samples, classes, num_samples, feature_size, k_num):
        self.k_num = k_num
        self.num_features = feature_size
        self.num_samples = num_samples
        self.training = sfix.Matrix(num_samples, feature_size)

        @for_range(num_samples)
        def f(i):
            @for_range(feature_size)
            def g(j):
                self.training[i][j] = samples[i][j]

        self.targets = sint.Array(num_samples)

        @for_range(num_samples)
        def f(i):
            self.targets[i] = classes[i]

    def compute_dists(self, test):
        # number of threads dependent on the number of classes
        num_features = self.num_features
        num_samples = self.num_samples
        dists = sfix.Array(num_samples)
        if num_samples % n_threads:
            raise Exception(
                'Number of threads must divide the number of sample elements')

        def thread_chunk():
            i = get_arg()
            chunk_size = num_samples / n_threads
            start_chunk = i * chunk_size

            for k in range(chunk_size):
                dists[start_chunk + k] = sum((self.training[j][start_chunk + k]
                                              - test[j])**2 for j in range(num_features))

        tape = program.new_tape(thread_chunk)  # define what function executes
        threads = [program.run_tape(tape, i) for i in range(
            n_threads)]  # execute each thread
        for i in threads:
            program.join_tape(i)  # wait until tape i has finished

        return dists

    def predict_alg1(self, test):
        start_timer(2)
        dists = self.compute_dists(test)
        print_ln('Time for one knn dist')
        stop_timer(2)

        dist_min = sfix(0)
        dist_min.store_in_mem(1)

        targets_knn = sint.Array(self.k_num)
        targets_knn.assign([None for i in range(self.k_num)])

        dists_knn = sfix.Array(self.k_num)
        dists_knn.assign([i for i in range(self.k_num)])

        start_timer(2)

        @for_range(self.k_num)
        def f(i):
            start_timer(1)
            dist, loc_target = _min(dists, self.targets, sfix.load_mem(1))
            print_ln('Time for one 1nn search')
            stop_timer(1)
            dist.store_in_mem(1)
            #print_ln('dist: %s, target: %s',dist.reveal(), loc_target.reveal())
            targets_knn[i] = loc_target
            dists_knn[i] = dist

        print_ln('Time for one knn search')
        stop_timer(2)
        print_ln('######################')

        return dists_knn, targets_knn
